# Build-a-Custom-Dock

This Guide allows you to craft a custom MacOS dock for your environment. I wrote this to be deployed from Jamf Pro but you can use any MDM.

Verified working on Monterey 12.3.1 and should be backwards compatible.

The custom dock will be built once, on first login, for any user that logs in to the Mac.

After the dock has been built once, it will not run again automatically, which is the intended behavior because we want our users to have our custom dock during onboarding and then give them the ability to make changes.

If you want to re-run the custom dock again, this is possible and can be scoped to a policy or placed in Self-Service. Continue reading for more info.

In my environment I have the Custom Dock to install on an Enrollment Trigger during onboarding. Then I also have it available in Self-Service for Users to run again anytime they want.

Huge shoutout to @ryangball for inspiring me to create this based on this (now deprecated) project!

https://github.com/ryangball/DockBuilder. 

I used this for a few years with good success but it is no longer working in Monterey or being supported. I used the principles from his scripting to create what you see here. 

**How to Build a Custom MacOS Dock**

1.	Download and install the latest version of dockutil: https://github.com/kcrawford/dockutil/releases
2.	Upload the package to Jamf Pro (i.e.. “dockutil-3.0.2.pkg”)
3.	Create a bash script that will utilize the dockutil binary: See **"BuildtheDock.sh"** in the repository.
4.	Feel free to modify lines 19+ of "buildthedock.sh" to create your own custom dock. 
5.	If you want to add a webloc web shortcut to the dock with a custom icon you need to create the .webloc file on your test mac and place the file in the filepath location of your choosing, package it with Jamf Composer, upload the PKG to Jamf Pro and then add that PKG to the main Policy (Step 18 of this guide). Ensure the line in your  “BuildtheDock.sh” looks like this (and replace the filepath and name with your specific webloc):

$DOCKUTIL_BINARY --add '/Library/Application Support/Dock Icons/Office 365.webloc' --label 'Office 365' --no-restart

6.	Name the file “BuildtheDock.sh”
7.	Use Jamf Composer to create a .pkg of that script and name it “BuildtheDockScript.pkg”
8.	Upload “BuildtheDockScript.pkg” to Jamf Pro.

**Create a Launch Agent (.plist) that will run the above script when loaded**

9.	Download launchd Package Creator: https://github.com/ryangball/launchd-package-creator
10.	Install and open launchd Package Creator
11.	Choose “Launch Agent” and name the Identifier “com.matt.buildadock”
12.	Version: “1.0”
13.	Click “Target Path” and navigate to the location you saved “BuildtheDock.sh”
14.	Check “Package the Target at /Library/Scripts”
15.	Check “RunAtLoad”
16.	Click “Create PKG” and name it “buildadockagent.pkg”
17.	Upload the PKG you just created to Jamf

**Create a bash script to run the launch agent as the current user**

18.	Upload “BuildtheDock_ReLoad LaunchAgent.sh" from this repository into your Jamf Pro.

**Putting it all together**

19.	Create a Jamf Policy and title it “Build Custom Dock”
20.	Attach the 3 packages we just created (or 4+ if you have weblocs in your script):

  #1. Dockutil-3.0.2.pkg  
  #2. Buildadockagent.pkg  
  #3. BuildtheDockScript.pkg  
  #4. Office365.webloc.pkg (optional)  

![image](https://user-images.githubusercontent.com/104439807/165319011-d4cc4cba-e839-47f4-b137-36f5c62780d6.png)


21.	Attach the Script “BuildtheDock_Reload LaunchAgent” and set the Priority to run After other actions

![image](https://user-images.githubusercontent.com/104439807/165331996-6653c5b4-f49a-4807-a0c6-e56278e761f9.png)


22.	Scope the Policy to your devices to run on a Custom Trigger. 

*Note*: This will only run ONCE for each User unless you proceed to the following steps.

**How to Re-load the Dock Anytime you Want**

Deleting the /Users/$currentuser/dockscrap.txt file will allow the launchd to run at User logon which will rebuild the dock again. You can automate this in Jamf Pro to reload the dock as many times as you want by doing the following:

1. Upload "A_Delete Dockscrap.sh" (found in this repository) to Jamf Pro.
2. Clone your "Build Custom Dock" Policy. Name it something else...like "Build Custom Dock - Self Service"
3. Add the "A_Delete Dockscrap.sh" to the policy. 
4. In this Policy you should have your 3+ PKG's (outlined in the original Policy explained above) and 2 scripts: "A_Delete Dockscrap.sh" (must run 1st) and "BuildtheDock_ReLoad LaunchAgent" (must run 2nd). In the Policy, set both scripts to run "After" the PKG's install. 
6. Scope the to Self-Service.

![image](https://user-images.githubusercontent.com/104439807/165342728-a6e54d98-2805-4991-b007-1bc4667f4c4c.png)


**Endnotes:**

To follow along with the install as the policy is being run:

1. Watch dockutil binary get installed here: /usr/local/bin/dockutil
2. Watch the "BuildtheDock.sh" file get installed here: /Library/Scripts/BuildtheDock.sh
3. Watch the  .plist file get installed here: /Library/LaunchAgents/com.matt.buildadock.plist
4. Watch dockscrap.txt file get installed here : /Users/$currentuser/dockscrap.txt
