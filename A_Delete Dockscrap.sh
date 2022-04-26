#!/bin/bash

#Set Variable for Current User
currentuser=$(/bin/ls -la /dev/console | /usr/bin/cut -d ' ' -f 4)
echo currentuser-variable = $currentuser

#Check to see if Dock has been built already
dockscrap=/Users/$currentuser/dockscrap.txt
echo "The dockscrap file is set to" $dockscrap

if [ -f $dockscrap ]; then
    echo "The dockscrap file exists. Deleting the file." 
    rm $dockscrap
    exit 0
fi

exit 0