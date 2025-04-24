# Manual Android Internal Release Process

This document outlines the steps to manually create and distribute an internal Android release for
the Memverse Flutter app using Firebase App Distribution.

## Prerequisites

* Firebase project set up with App Distribution enabled.
* Firebase CLI installed and configured (for future automation).
* Git installed and configured.
* Flutter SDK installed and configured.
* Android development environment set up.

## 1. Prepare for Release

* **Ensure Code Stability:** Make sure the `main` branch (or your release branch) is stable, all
  tests pass, and the code is formatted correctly.
  ```bash
  # Optional: Run checks if you have a script
  ./scripts/check_before_commit.sh
  ```
* **Get the Short Commit Hash:** You'll need this for the version name.
  ```bash
  git rev-parse --short HEAD
  ```
  *Example output: `a1b2c3d`*

## 2. Update Version Information

* **`pubspec.yaml`:**
    * Locate the `version:` line.
    * Increment the build number (the part after the `+`) by 10. For example, if it's `1.2.3+5`,
      change it to `1.2.3+15`.
    * Update the version name (the part before the `+`) to include the short commit hash obtained in
      the previous step. For example: `1.2.3 (a1b2c3d)`.
    * The final line should look something like: `version: 1.2.3 (a1b2c3d)+15`

## 3. Commit Version Changes

* Commit the changes to `pubspec.yaml` and `android/app/build.gradle`.
  ```bash
  git add pubspec.yaml android/app/build.gradle
  git commit -m "chore: Bump version for release v1.2.3 (a1b2c3d)+15"
  ```
  *(Replace `1.2.3 (a1b2c3d)+15` with your actual version)*

## 4. Create Git Tag

* Tag the commit with the version number. Use an annotated tag (`-a`) to include a message.
  ```bash
  git tag -a v1.2.3+15 -m "Release version 1.2.3 (a1b2c3d), build 15"
  git push origin v1.2.3+15
  ```
  *(Replace `v1.2.3+15` and the message with your actual version and build number)*

## 5. Build the Android App Bundle (AAB)

* Clean the project (optional but recommended).
  ```bash
  flutter clean
  ```
* Build the release AAB.
  ```bash
  flutter build appbundle --release
  ```
* The output AAB file will be located at `build/app/outputs/bundle/release/app-release.aab`.

## 6. Distribute via Firebase App Distribution (Manual)

* **Open Firebase Console:** Navigate to your project in
  the [Firebase Console](https://console.firebase.google.com/).
* **Go to App Distribution:** In the left-hand menu, under "Release & Monitor", select "App
  Distribution".
* **Select Android App:** Make sure your Android app is selected.
* **Upload AAB:** Drag and drop the generated `app-release.aab` file onto the "Releases" tab or use
  the "Get Started" / "Upload" button.
* **Add Testers/Groups:** Once the upload is complete, select the tester groups or individual
  testers you want to distribute this release to.
* **Add Release Notes:** This is crucial! Provide clear notes about what's new in this release,
  known issues, and specific areas to test. You can usually add these directly in the Firebase
  console during the distribution step.
* **Distribute:** Click the "Distribute" button. Testers will receive an email notification.

## 7. Managing Testers in Firebase

* In the Firebase App Distribution section, go to the "Testers & Groups" tab.
* **Add Individual Testers:** Enter email addresses to invite specific testers.
* **Create Groups:** Create groups (e.g., "QA Team", "Internal Staff") and add testers to them. This
  makes it easier to manage distributions to multiple people.
* Testers need to accept the invitation in the email they receive from Firebase to be able to
  download builds.

## Next Steps: Command-Line Distribution (Automation)

While this document covers the manual process, you can automate distribution using the Firebase CLI.

* **Log in to Firebase:**
  ```bash
  firebase login
  ```
* **Distribute the AAB:**
  ```bash
  firebase appdistribution:distribute build/app/outputs/bundle/release/app-release.aab \
      --app <YOUR_FIREBASE_APP_ID> \
      --release-notes "Release v1.2.3 (a1b2c3d): Fixed bug X, added feature Y." \
      --groups "qa-team,internal-staff"
  ```
    * Replace `<YOUR_FIREBASE_APP_ID>` with your actual Firebase App ID (find it in Project
      settings > General > Your apps).
    * Update `--release-notes` with your specific notes.
    * Update `--groups` with the comma-separated list of your Firebase tester group aliases. You can
      also use `--testers` for individual email addresses.

This command-line approach can be integrated into CI/CD pipelines for fully automated internal
releases.
