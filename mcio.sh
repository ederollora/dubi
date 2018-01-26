#!/bin/bash

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

echo -e "\n[INFO] - Searching for the pom.xml file in the current directory"
numPom=$(ls -l ${PWD} | grep pom.xml | wc -l)
pomFile=""
appName=""

if [ "$numPom" -lt 1 ];
then
  echo -e "[POM FILE] - NOT FOUND"
  echo -e "[POM FILE] - Looks like you are not in your project's directory"
  exit
else
  echo -e "[POM FILE] - FOUND"
  pomFile=${PWD}"/pom.xml"
fi


while read_dom; do
    if [[ $ENTITY = "onos.app.name" ]]; then
        echo -e "[APP NAME] - FOUND: $CONTENT"
        appName=$CONTENT
        break
    fi
done < $pomFile

echo -e "[APP DEACTIVATE] - TRYING TO DEACTIVATE IF $appName IS ACTIVATED"
output=$(/home/student/onos/tools/package/runtime/bin/onos-app localhost deactivate $appName)

echo -e "[APP UNINSTALL] - TRYING TO UNINSTALL IF $appName IS INSTALLED"
output=$(/home/student/onos/tools/package/runtime/bin/onos-app localhost uninstall $appName)

echo "[APP BUILD] - TRYING TO BUILD THE $appName APP"
output=$(mvn clean install -DskipTests)

if grep -q "BUILD SUCCESS" <<< "$output";
then
  message=$(echo "$output" | grep "BUILD SUCCESS")
  echo -e "[APP BUILD] - $appName BUILD WAS SUCCESSFUL"
  echo -e "[APP BUILD] - MESSAGE  -> $message"

  numFiles=$(ls -l target/*.oar | wc -l)

  if [ "$numFiles" -lt 2 ];
  then
    fileName=$(ls target/*.oar | xargs -n 1 basename)
    filePath=${PWD}/target/$fileName
    output=$(/home/student/onos/tools/package/runtime/bin/onos-app localhost install $filePath)
    if grep -q "\"state\":\"INSTALLED\"" <<< "$output";
    then
      echo -e "[APP BUILD] - INSTALLATION OF $appName WAS SUCCESFUL"
    else
      echo -e "[APP BUILD] - THERE WAS AN ERROR WITH THE .oar FILE INSTALLATION"
      echo -e "[APP BUIKD] - ERROR:"
      echo "$output"
    fi
  fi
else
  message=$(echo "$output" | grep ERROR)
  echo -e "[APP BUILD] - BUILDING $appName WAS NOT SUCCESSFUL"
  echo -e "[APP BUILD] - ERROR:"
  echo -e "$message"
fi


