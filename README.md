# Build-a-Custom-Dock

This Guide allows you to craft a custom MacOS dock for your environment. I wrote this to be deployed from Jamf Pro but you can use any MDM.

The custom dock will be built once, on first login, for any user that logs in to the Mac.

After the dock has been built once, it will not run again automatically, which is the intended behavior because we want our users to have our custom dock during onboarding and then give them the ability to make changes.

If you want to re-run the custom dock again, this is possible and can be scoped to a policy or placed in Self-Service.

In my environment I have the Custom Dock to install on an Enrollment Trigger and then I also have it available in Self-Service for Users to run again anytime they want.

**How to Build a Custom MacOS Dock**

1.	Download and install the latest version of dockutil: https://github.com/kcrawford/dockutil/releases
2.	Upload the package to Jamf Pro (i.e.. “dockutil-3.0.2.pkg”)
3.	Create a bash script that will utilize the dockutil binary: See **"BuildtheDock.sh"** in the repository.
4.	Feel free to modify lines 19+ to create your own custom dock. 
5.	If you want to add a webloc to the dock you need to create the .webloc file on your test mac and place the file in the filepath location of your choosing, package it with composer, upload the PKG to Jamf and add that PKG to the main Policy (Step 18 of this guide). Ensure the line in your  “BuildtheDock.sh” looks like this (replacing the filepath to your specific webloc):

$DOCKUTIL_BINARY --add '/Library/Application Support/Dock Icons/Office 365.webloc' --label 'Office 365' --no-restart

6.	Name the file “BuildtheDock.sh”
7.	Use Jamf Composer to create a .pkg of that script and name it “BuildtheDockScript.pkg”
8.	Upload “BuildtheDockScript.pkg” to Jamf Pro.

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
18.	Attach the 3 packages we just created (or 4+ if you have weblocs in your script):

  #1. Dockutil-3.0.2.pkg
  #2. Buildadockagent.pkg
  #3. BuildtheDockScript.pkg
  #4. Office365.webloc.pkg (optional)

![image](https://user-images.githubusercontent.com/104439807/165319011-d4cc4cba-e839-47f4-b137-36f5c62780d6.png)


19.	Attach the Script “BuildtheDock_Reload LaunchAgent” and set the Priority to run After other actions

![image](https://user-images.githubusercontent.com/104439807/165331996-6653c5b4-f49a-4807-a0c6-e56278e761f9.png)


20.	Scope the Policy to your devices to run on a Custom Trigger.

**How to Re-load the Dock**

1. Upload "A_Delete Dockscrap.sh" to Jamf Pro.
2. Create a Policy to...

**Endnotes:**

To follow along with the install as the policy is being run:

1. Watch dockutil binary get installed here: /usr/local/bin/dockutil
2. Watch the "BuildtheDock.sh" file get installed here: /Library/Scripts/BuildtheDock.sh
3. Watch the  .plist file get installed here: /Library/LaunchAgents/com.matt.buildadock.plist




