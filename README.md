# MCIO

The acronym stands for Maven Clean Install Onos. It wraps the commands `maven clean install` and `onos-app install` together to execute them and track their status. It builds you own ONOS application and install it on the controller

## Requirements

* ONOS (Tested with version 1.7.0)
* Maven (Tested with version 3.3.9)
* Karaf (Tested with version 3.0.5)
* Oracle Java 8

Make sure **$JAVA_HOME** is properly set and that the file **bash_profile** included in the cloned onos folder has been sourced (in 1.7.0 -> $ONOS_ROOT/tools/dev/bash_profile). This is important because without adding the **bash_profile** commands like `mvn` or `onos-app` would not be recognized:

## Getting started

To get a copy of the project you should run:

```bash
git clone https://github.com/ederollora/mcio.git
```

Once the repository has been cloned, I would suggest to create and alias for the script. You can see where the script resides by running `pwd` inside the directory that contains script. Add the directory (appending the file to it) to the **bashrc** file in your home directory. Finally give mcio.sh **execution permissions**:

Open bashrc file:
```bash
nano ~/.bashrc
```
Go to the end of the file and append:
```bash
alias mcio='/home/user/mcio/mcio.sh' (considering you cloned it in your home directory)
```
Close it, save it and source the file:
```bash
source ~/.bashrc
```

Add execution permissions to the original script:
```bash
chmod +x /home/user/mcio/mcio.sh
```

## Usage

To run the script just go to your ONOS app directory (where you typed onos-create-app), the pom.xml file should be there:
```bash
cd /home/user/my-onos-app/`
mcio
```

## Output

Successfull:

user@machine:~/onos_apps/myapp$ mcio

> [INFO] - Searching for the pom.xml file in the current directory
> [INFO] - pom.xml found, continuing with the process
> [INFO] - Running: $ mvn clean install -DskipTests
> [building] /\n
> [SUCCESS] - Build status -> Correct
> [SUCCESS] - Message      -> [INFO] BUILD SUCCESS
> [INFO] - Continuing with OAR file installation
> [SUCCESS] - Installation successful -> INSTALLED keyword found`
