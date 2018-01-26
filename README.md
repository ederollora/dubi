# ONOS DUBI

The acronym stands for ONOS APP Deactivate, Uninstall, Build & Install. It wraps the commands `onos-app deactivate`, `onos-app uninstall`, `maven clean install` and `onos-app install` together to execute them according to your app's name (extracted from pom.xml). It deactivates and uninstall of your app. Then it builds the application and installs it in the controller.

## Requirements

* ONOS (Tested with version 1.7.0)
* Maven (Tested with version 3.3.9)
* Karaf (Tested with version 3.0.5)
* Oracle Java 8

Make sure **$JAVA_HOME** is properly set and that the file **bash_profile** included in the cloned onos folder has been sourced (in 1.7.0 -> $ONOS_ROOT/tools/dev/bash_profile). This is important because without adding the **bash_profile**, commands like `mvn` or `onos-app` would not be recognized. The app has also been tested with onos 1.13.0. 

## Getting started

To get a copy of the project you should run:

```bash
git clone https://github.com/ederollora/dubi.git
```

Once the repository has been cloned, I would suggest to create and alias for the script. You can see where the script resides by running `pwd` inside the directory that contains script. Add the directory (appending the file to it) to the **bashrc** file in your home directory. Finally give mcio.sh **execution permissions**:

Open bashrc file:
```bash
nano ~/.bashrc
```
Go to the end of the file and append (considering you cloned it in your home directory):
```bash
alias dubi='/home/user/dubi/dubi.sh'
```
Close it, save it and source the file:
```bash
source ~/.bashrc
```

Add execution permissions to the original script:
```bash
chmod +x /home/user/dubi/dubi.sh
```

## Usage

To run the script just go to your ONOS app directory (where you typed onos-create-app), the pom.xml file should be there:
```bash
cd /home/user/my-onos-app/
dubi
```

## Output

It should look like this:

user@machine:~/onos_apps/myapp$ mcio

> [INFO] - Searching for the pom.xml file in the current directory
> [POM FILE] - FOUND
> [APP NAME] - FOUND: org.student.lb
> [APP DEACTIVATE] - TRYING TO DEACTIVATE IF org.student.lb IS ACTIVATED
> [APP UNINSTALL] - TRYING TO UNINSTALL IF org.student.lb IS INSTALLED
> [APP BUILD] - TRYING TO BUILD THE org.student.lb APP
> [APP BUILD] - org.student.lb BUILD WAS SUCCESSFUL
> [APP BUILD] - MESSAGE  -> [INFO] BUILD SUCCESS
> [APP BUILD] - INSTALLATION OF org.student.lb WAS SUCCESFUL
