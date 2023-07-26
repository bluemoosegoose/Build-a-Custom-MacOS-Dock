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
$DOCKUTIL_BINARY --add '/System/Applications/System Settings.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Self Service.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/System/Cryptexes/App/System/Applications/Safari.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Firefox.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Google Chrome.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Library/Application Support/Dock Icons/Office 365.webloc' --label 'Office 365' --no-restart
$DOCKUTIL_BINARY --add '~/Downloads' --view fan --display stack
echo Added Downloads-Fan View-Stack Display

#Create the dockscrap file
touch /Users/$currentuser/dockscrap.txt
