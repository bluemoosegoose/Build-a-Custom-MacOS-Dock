# Build-a-Custom-Dock

How to Build a Custom MacOS Dock
1.	Download and install the latest version of dockutil: https://github.com/kcrawford/dockutil/releases
2.	Upload the package to Jamf Pro (i.e.. “dockutil-3.0.2.pkg”)
3.	Create a bash script that will utilize the dockutil binary:

#!/bin/bash
 
#Make time for other stuff to finish
/bin/sleep 3
 
# Set Variable for Dockutil Binary
DOCKUTIL_BINARY=/usr/local/bin/dockutil
 
#Set Variable for Sleep
sleep=/bin/sleep
 
#Set Variable for Current User
currentuser=$(/bin/ls -la /dev/console | /usr/bin/cut -d ' ' -f 4)
 
#Create a log file of this script
exec > /Users/$currentuser/docklog.txt 2>&1
 
#Log the Variables
echo dockutil-variable = $DOCKUTIL_BINARY
echo sleep-variable = $sleep
echo currentuser-variable = $currentuser
 
############################################################
 
#Check to see if Dock has been built already
dockscrap=/Users/$currentuser/dockscrap.txt
echo "The dockscrap file is set to" $dockscrap
 
if [ -f $dockscrap ]; then
    echo "The dockscrap file exists. Exiting." 
    exit 0
fi
 
echo No dockscrap found. Continuing to build the dock!
 
############################################################
 
#Clear the Dock
echo Removing all Dock Items
$DOCKUTIL_BINARY --remove all --no-restart
 
#sleep for 2 seconds
$sleep 2
 
#Build the Dock
$DOCKUTIL_BINARY --add '/System/Applications/Launchpad.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/System/Applications/System Preferences.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Self Service.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Safari.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Firefox.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Google Chrome.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Library/Application Support/Dock Icons/Office 365.webloc' --label 'Office 365' --no-restart
$DOCKUTIL_BINARY --add '~/Downloads' --view fan --display stack
echo Added Downloads-Fan View-Stack Display
 
#Create the dockscrap file
touch /Users/$currentuser/dockscrap.txt



4.	After modifying the script to create a custom dock, name it “BuildtheDock.sh”
5.	Use Composer to create a .pkg of that script and name it “BuildtheDockScript.pkg”
6.	Upload “BuildtheDockScript.pkg” to Jamf
Create a Launch Agent (.plist) that will run the above script when loaded
7.	Download launchd Package Creator: https://github.com/ryangball/launchd-package-creator
8.	Install and open launchd Package Creator
9.	Choose “Launch Agent” and name the Identifier “com.matt.buildadock”
10.	Version: “1.0”
11.	Click “Target Path” and navigate to the location you saved “BuildtheDock.sh”
12.	Check “Package the Target at /Library/Scripts”
13.	Check “RunAtLoad”
14.	Click “Create PKG” and name it “buildadockagent.pkg”
15.	Upload the PKG you just created to Jamf
Create a bash script to run the launch agent as the current user
16.	Copy/Paste the following script in Jamf Pro and name the Script “BuildtheDock_ReLoad LaunchAgent”
#!/bin/bash

#Set Variable for Current User
currentuser=$(/bin/ls -la /dev/console | /usr/bin/cut -d ' ' -f 4)
echo currentuser-variable = $currentuser

#Make Sure the Launch Agent is Unloaded which allows for re-run
sudo -u $currentuser launchctl unload -w /Library/LaunchAgents/com.matt.buildadock.plist
echo Finished unloading launchagent

#Give it some time
/bin/sleep 2

#Load the Launch Agent
sudo -u $currentuser launchctl load -w /Library/LaunchAgents/com.matt.buildadock.plist
echo Finished loading launchagent

#Allow the Dock to build before the Jamf Policy says it's Done
/bin/sleep 7

Putting it all together
17.	Create a Jamf Policy and title it “Build Custom Dock”
18.	Attach the 3 packages we just created:
a.	Dockutil-3.0.2.pkg
b.	Buildadockagent.pkg
c.	BuildtheDockScript.pkg
19.	Attach the Script “BuildtheDock_Reload LaunchAgent” and set the Priority to run After other actions
20.	Scope the Policy to your devices. This can be run from Self-Service or Custom Trigger. It can be re-run whenever needed.

Endnotes:
To follow along with the install as the policy is being run:
Watch dockutil binary get installed here: /usr/local/bin/dockutil
Watch the .sh file get installed here: /Library/Scripts/BuildtheDock.sh
Watch the  .plist file get installed here: /Library/LaunchAgents/com.matt.buildadock.plist

If you want to add a webloc to the dock you need to create the .webloc file, package it with composer, upload the PKG to Jamf, add that PKG to the main Policy, ensure your  “BuildtheDock.sh” looks like this: 
$DOCKUTIL_BINARY --add '/Library/Application Support/Dock Icons/Office 365.webloc' --label 'Office 365' --no-restart



