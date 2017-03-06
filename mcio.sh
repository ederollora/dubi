#!/bin/bash

echo -e "\n[INFO] - Searching for the pom.xml file in the current directory"
numPom=$(ls -l ${PWD} | grep pom.xml | wc -l)

if [ "$numPom" -lt 1 ];
then
  echo -e "[ERROR] - No pom.xml file was found"
  echo -e "[ERROR] - Looks like you are not in your project's directory"
  exit
else
  echo -e "[INFO] - pom.xml found, continuing with the process"
fi

echo "[INFO] - Running: $ mvn clean install -DskipTests"

#http://stackoverflow.com/questions/20017805/bash-capture-output-of-command-run-in-background
exec 3< <(mvn clean install -DskipTests)
pid=$! # Get PID of background command

# http://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-working-indicator
spin[0]="-"
spin[1]="\\"
spin[2]="|"
spin[3]="/"

echo -n "[building] ${spin[0]}"

#http://stackoverflow.com/questions/27372224/bash-script-ensure-process-has-terminated-without-waiting-unnecessarily
while kill -0 $pid >/dev/null 2>&1;
do
  for i in "${spin[@]}"
  do
        echo -ne "\b$i"
        sleep 0.1
  done
done
echo "\n"

output=$(cat <&3)

if grep -q "BUILD SUCCESS" <<< "$output";
then
  message=$(echo "$output" | grep "BUILD SUCCESS")
  echo -e "[SUCCESS] - Build status -> Correct"
  echo -e "[SUCCESS] - Message      -> $message"
  echo -e "[INFO] - Continuing with OAR file installation"
  numFiles=$(ls -l target/*.oar | wc -l)

  if [ "$numFiles" -lt 2 ];
  then
    fileName=$(ls target/*.oar | xargs -n 1 basename)
    filePath=${PWD}/target/$fileName
    output=$(onos-app localhost install $filePath)
    if grep -q "\"state\":\"INSTALLED\"" <<< "$output";
    then
      echo -e "[SUCCESS] - Installation successful -> INSTALLED keyword found"
    else
      echo -e "[ERROR] - There was an error with the .oar file installation"
      echo -e "[ERROR] - Refer to the following output:"
      echo "$output"
    fi
  else
    num=0
    files=()
    echo -e "More than 1 file found."
    count=0
    echo "$fileName" |
      while read x;
      do
        echo -e "Choose the number corresponsing to the file:"
        echo -e "- $x [$((count+1))]\n";
        file[count]=$x
      done
    while [ num<1 || num>numFiles ]; do
      echo "Insert the number: "
      read num
    done
      output=$(onos-app localhost install ${PWD}/target/${files[$((num-1))]})
      if grep -q "\"state\":\"INSTALLED\"" <<< "$output";
      then
        echo -e "[SUCCESS] - Installation successful -> INSTALLED keyword found"
      else
        echo -e "[ERROR] - There was an error with the .oar file installation"
        echo -e "[ERROR] - Refer to the following output:"
        echo "$output"
      fi
  fi
else
  message=$(echo "$output" | grep ERROR)
  echo -e "[ERROR] - Build errors were encountered. Refer to the following:"
  echo -e "$message"
fi
