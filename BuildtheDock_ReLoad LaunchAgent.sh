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