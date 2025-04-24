Subject: feat(android): MEM-82 Implement Git hash in version, add build scripts

Description:

This PR addresses MEM-82 by adding Android build/install scripts and incorporating the Git hash into
the `versionName`.

**Key Changes:**

* **Git Hash in Version Name**: Modified `android/app/build.gradle` to append the short Git commit
  hash to `versionName` (e.g., `0.1.2+63faf12`). This makes the specific commit easily identifiable
  in the app's info within Android settings.
* **APK Naming for Release**: Updated `android/app/build.gradle` to rename release APKs using the
  format `memverse_<version>_<githash>_release.apk`.
* **Build Scripts (`scripts/android/`):**
    * Created `build_and_install_staging_debug.sh`:
        * Builds a staging flavor debug APK (`-t lib/main_staging.dart`).
        * Passes `FLAVOR` and `CLIENT_ID` via `--dart-define`.
        * Installs the APK to a connected device/emulator using `adb install`.
        * Checks the installed version using `adb shell dumpsys package ...`.
        * Creates a local Git tag (`staging-v<version>-<hash>`) for the build.
        * Opens the corresponding GitHub tag URL in Chrome (noting it requires a manual
          `git push origin <tag>`).
        * Provides instructions for the manual tag push.
    * Created `build_production_release.sh`:
        * Builds a production flavor release APK (`-t lib/main_production.dart`).
        * Passes `FLAVOR` and `CLIENT_ID` via `--dart-define`.
        * Relies on Gradle for signing (marked with `TODO (MEM-84)` for verification).
        * Locates the renamed release APK.
    * Created `_common_build_utils.sh` to share common logic (finding project root, getting version
      info) between the build scripts.
* **Documentation:**
    * Updated `README.md` with instructions for the new build scripts.
    * Added TODOs pointing to MEM-84 for further refinement (release signing, Fastlane, Gradle
      linter errors).
    * Created `temporary_jira_ticket.txt` for MEM-84 details.

**Testing:**

* The `build_and_install_staging_debug.sh` script has been run successfully, confirming build,
  install, version check, tag creation, and browser opening functionality.
* Manual verification of the version name in Android app settings is recommended after running the
  staging script.
* The `build_production_release.sh` script builds successfully, but full end-to-end testing (signing
  verification, installation) should be done as part of MEM-84.

**Related Ticket:** MEM-82
