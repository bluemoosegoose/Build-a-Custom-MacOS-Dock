# Build-a-Custom-Dock

**How to Build a Custom MacOS Dock**

1.	Download and install the latest version of dockutil: https://github.com/kcrawford/dockutil/releases
2.	Upload the package to Jamf Pro (i.e.. “dockutil-3.0.2.pkg”)
3.	Create a bash script that will utilize the dockutil binary: See "BuildtheDock.sh" in the repository.
4.	Feel free to modify lines 19+ to create your own custom dock. Keep the file name “BuildtheDock.sh”
6.	Use Jamf Composer to create a .pkg of that script and name it “BuildtheDockScript.pkg”
7.	Upload “BuildtheDockScript.pkg” to Jamf Pro.

**Create a Launch Agent (.plist) that will run the above script when loaded**

7.	Download launchd Package Creator: https://github.com/ryangball/launchd-package-creator
8.	Install and open launchd Package Creator
9.	Choose “Launch Agent” and name the Identifier “com.matt.buildadock”
10.	Version: “1.0”
11.	Click “Target Path” and navigate to the location you saved “BuildtheDock.sh”
12.	Check “Package the Target at /Library/Scripts”
13.	Check “RunAtLoad”
14.	Click “Create PKG” and name it “buildadockagent.pkg”
15.	Upload the PKG you just created to Jamf

**Create a bash script to run the launch agent as the current user**

16.	Upload “BuildtheDock_ReLoad LaunchAgent.sh" from this repository into your Jamf Pro.

**Putting it all together**

17.	Create a Jamf Policy and title it “Build Custom Dock”
18.	Attach the 3 packages we just created:

1 -->	Dockutil-3.0.2.pkg
2 -->	Buildadockagent.pkg
3 -->	BuildtheDockScript.pkg

19.	Attach the Script “BuildtheDock_Reload LaunchAgent” and set the Priority to run After other actions
20.	Scope the Policy to your devices. This can be run from Self-Service or Custom Trigger. It can be re-run whenever needed.

Endnotes:
To follow along with the install as the policy is being run:
Watch dockutil binary get installed here: /usr/local/bin/dockutil
Watch the "BuildtheDock.sh" file get installed here: /Library/Scripts/BuildtheDock.sh
Watch the  .plist file get installed here: /Library/LaunchAgents/com.matt.buildadock.plist

If you want to add a webloc to the dock you need to create the .webloc file, package it with composer, upload the PKG to Jamf, add that PKG to the main Policy, ensure your  “BuildtheDock.sh” looks like this: 
$DOCKUTIL_BINARY --add '/Library/Application Support/Dock Icons/Office 365.webloc' --label 'Office 365' --no-restart



