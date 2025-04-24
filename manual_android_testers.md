# Manual Android Tester Instructions

Welcome, tester! Thank you for helping improve the Memverse app. This guide explains how to install
internal test builds distributed via Firebase App Distribution and alternative methods.

## Receiving Invitations

* You will receive an email invitation from Firebase App Distribution when a new build is available
  for you or when you are first added as a tester.
* **You MUST accept the invitation** by clicking the link in the email to be able to install builds.

## Installation Methods (Preferred to Least Preferred)

### 1. Firebase App Distribution (Android App - Recommended)

This is the easiest and recommended way to manage test builds.

1. **Accept Invite:** Click the link in the Firebase invitation email on your Android device.
2. **Follow Instructions:** Google Play will guide you to install the "Firebase App Tester" app (if
   you haven't already).
3. **Sign In:** Open the Firebase App Tester app and sign in with the same Google account that
   received the invitation email.
4. **Install Build:** The Memverse app build will appear in the App Tester app. Tap on it and then
   tap "Download". Once downloaded, Android will prompt you to install the update.
5. **Future Updates:** You'll get notifications (email and/or within the App Tester app) when new
   builds are ready. Simply open the App Tester app to download and install them.

### 2. Firebase App Distribution (Web Clip / Browser)

If you prefer not to install the App Tester app, you can use the web interface directly in your
browser.

1. **Accept Invite:** Click the link in the Firebase invitation email on your Android device.
2. **Web Page:** Instead of being redirected to Google Play, a Firebase web page will open in your
   browser.
3. **Download:** Find the Memverse app build and tap the download button.
4. **Install:** Your browser will download the APK file. You may need to:
    * Open your browser's download list or use a file manager app to find the downloaded APK.
    * Tap the APK file.
    * **Enable Installation from Unknown Sources:** Android will likely warn you about installing
      apps from unknown sources. You need to grant permission to your browser or file manager app to
      install apps. Follow the on-screen prompts.
    * Confirm the installation.
5. **Future Updates:** You will still receive email notifications for new builds. You'll need to
   repeat steps 1-4 for each new version by clicking the link in the email again.

### 3. Google Drive / Gmail / Shared Link (APK File)

If the developers share an `.apk` file directly via Google Drive, Gmail attachment, Dropbox, etc.:

1. **Access File:** Open the shared link or email attachment on your Android device.
2. **Download:** Download the `.apk` file to your device.
3. **Install:** Follow steps 4.1 to 4.5 from the "Web Clip / Browser" method above (find the
   downloaded file, tap it, grant permissions if needed, install).
4. **Future Updates:** You will need to manually obtain and install new APK files shared this way.

### 4. ADB Install (Advanced - Requires PC)

This method requires a computer, USB cable, and enabling developer options on your Android device.
It's generally used by developers or for troubleshooting specific installation issues.

1. **Enable Developer Options & USB Debugging:** On your Android device, go to Settings > About
   phone and tap "Build number" seven times. Then go back to Settings > System > Developer options
   and enable "USB debugging".
2. **Install ADB:** Ensure you have the Android SDK Platform Tools (which includes ADB) installed on
   your computer.
3. **Connect Device:** Connect your Android device to your computer via USB. Authorize the computer
   on your device when prompted.
4. **Obtain APK:** Get the `.apk` file onto your computer.
5. **Open Terminal/Command Prompt:** Navigate to the directory where you saved the APK.
6. **Run ADB Command:** Execute the following command: