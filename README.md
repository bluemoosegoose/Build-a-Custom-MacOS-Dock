# Build-a-Custom-Dock

This Guide allows you to craft a custom MacOS dock for your environment. I wrote this to be deployed from Jamf Pro but you can use any MDM.

Verified working on Sonoma 14.1.1 and is backwards compatible to Catalina.

The custom dock will be built once, on first login, for any user that logs in to the Mac.

After the dock has been built once, it will not run again automatically, which is the intended behavior because we want our users to have our custom dock during onboarding and then give them the ability to make changes.

If you want to re-run the custom dock again, this is possible and can be scoped to a policy or placed in Self-Service. Continue reading for more info.

In my environment I have the Custom Dock to install on an Enrollment Trigger during onboarding. Then I also have it available in Self-Service for Users to run again anytime they want.


**How to Build a Custom MacOS Dock**

1.	Download and install the latest version of dockutil: https://github.com/kcrawford/dockutil/releases
2.	Upload the package to Jamf Pro (i.e.. “dockutil-3.0.2.pkg”)

**Create a bash script that will utilize the dockutil binary**

3.	Download **"BuildtheDock.sh"** from the repository.
4.	Feel free to modify lines 46+ of "buildthedock.sh" to create your own custom dock. 
5.	If you want to add a webloc web shortcut to the dock with a custom icon you need to create the .webloc file on your test mac and place the file in the filepath location of your choosing, package it with Jamf Composer, upload the PKG to Jamf Pro and then add that PKG to the main Policy (Step 20 of this guide). Ensure the line in your  “BuildtheDock.sh” looks like this (and replace the filepath and name with your specific webloc):

$DOCKUTIL_BINARY --add '/Library/Application Support/Dock Icons/Office 365.webloc' --label 'Office 365' --no-restart

6.	Name the file “BuildtheDock.sh” and place it in "/Library/Scripts".
7.	Drag and drop “BuildtheDock.sh” from "/Library/Scripts" (this is where it will be installed later on) into Jamf Composer under "Sources". Make sure to drill down to "BuildtheDock.sh" and assign Root permissions of 775 (optionally change for your environment). Click "Build as PKG" and name it “BuildtheDockScript.pkg”.
8.	Upload “BuildtheDockScript.pkg” you just created to Jamf Pro.

**Create a Launch Agent (.plist) that will run the above script when loaded**

9.	Download launchd Package Creator: https://github.com/ryangball/launchd-package-creator
10.	Install and open launchd Package Creator.
11.	Choose “Launch Agent” and name the Identifier “com.matt.buildadock”
12.	Version: “1.0”
13.	Click “Target Path” and navigate to the location you saved “BuildtheDock.sh”
14.	Check “Package the Target at /Library/Scripts”
15.	Check “RunAtLoad”
16.	Click “Create PKG”, name it “buildadockagent” and save it to your Downloads (or some other location you can access) Verify it created successfully in this location.
17.	Upload "buildadockagent.pkg" to Jamf.

**Create a bash script to run the launch agent as the current user**

18.	Upload **“BuildtheDock_ReLoad LaunchAgent.sh"** from this repository into your Jamf Pro.

**Putting it all together**

19.	Create a Jamf Policy and title it “Build Custom Dock”
20.	Attach the 3 packages we just created (or 4+ if you have weblocs in your script):

  #1. Dockutil-3.0.2.pkg  
  #2. Buildadockagent.pkg  
  #3. BuildtheDockScript.pkg  
  #4. Office365.webloc.pkg (optional)  

![image](https://user-images.githubusercontent.com/104439807/165319011-d4cc4cba-e839-47f4-b137-36f5c62780d6.png)


21.	Attach the Script **“BuildtheDock_Reload LaunchAgent.sh”** and set the Priority to run After other actions.

![image](https://user-images.githubusercontent.com/104439807/165331996-6653c5b4-f49a-4807-a0c6-e56278e761f9.png)


22.	Scope the Policy to your devices to run on a Custom Trigger. 

*Note*: This will only run ONCE for each User unless you proceed to the following steps.

**How to Re-load the Dock Anytime you Want**

Deleting the "dockscrap.txt" file from "/Users/$currentuser" will allow the launchd to run at User logon which will rebuild the dock again (and recreate the "dockscrap.txt" file). You can automate this in Jamf Pro to reload the dock as many times as you want by doing the following:

1. Upload "A_Delete Dockscrap.sh" (found in this repository) to Jamf Pro.
2. Clone your "Build Custom Dock" Policy. Name it something else...like "Build Custom Dock - Self Service"
3. Add the "A_Delete Dockscrap.sh" to the policy. 
4. In this Policy you should have your 3+ PKG's (outlined in the original Policy explained above) and 2 scripts: "A_Delete Dockscrap.sh" (must run 1st) and "BuildtheDock_ReLoad LaunchAgent" (must run 2nd). In the Policy, set both scripts to run "After" the PKG's install. It's important to keep the naming convention as just described, or else Jamf will not run the scripts in the correct order and it will fail.
6. Scope to Self-Service.

![image](https://user-images.githubusercontent.com/104439807/165342728-a6e54d98-2805-4991-b007-1bc4667f4c4c.png)


**Endnotes:**

To follow along with the install as the policy is being run:

1. Watch dockutil binary get installed here: /usr/local/bin/dockutil
2. Watch the "BuildtheDock.sh" file get installed here: /Library/Scripts/BuildtheDock.sh
3. Watch the  .plist file get installed here: /Library/LaunchAgents/com.matt.buildadock.plist
4. Watch dockscrap.txt file get installed here : /Users/$currentuser/dockscrap.txt
5. Check the log at: /Users/$currentuser/docklog.txt
