#!/bin/bash

/bin/sleep 3

# Set variables to our tools for consistency
DOCKUTIL_BINARY=/usr/local/bin/dockutil
echo dockutil-variable = $DOCKUTIL_BINARY
sleep=/bin/sleep
echo sleep-variable = $sleep

#Clear the Dock
echo Attempting to remove all Dock Items
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
