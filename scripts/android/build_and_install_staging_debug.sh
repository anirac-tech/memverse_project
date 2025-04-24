#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Navigate two levels up to the project root
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

# Change to the project root directory
cd "$PROJECT_ROOT"

# Exit immediately if a command exits with a non-zero status.
set -e

FLAVOR="staging"
BUILD_TYPE="debug"

echo "--------------------------------------------------"
echo "Starting Staging Debug Build and Install Process"
echo "--------------------------------------------------"
echo "IMPORTANT: Please ensure an Android device or emulator is connected via ADB."
echo "Waiting 5 seconds..."
sleep 5

# Get the current version and git hash
VERSION=$(grep 'version:' pubspec.yaml | cut -d ' ' -f 2 | cut -d '+' -f 1)
GIT_HASH=$(git rev-parse --short HEAD)
EXPECTED_VERSION_STRING="${VERSION}+${GIT_HASH}" # Version string shown in app info

# Expected APK name for flavored debug builds
EXPECTED_APK_NAME="app-${FLAVOR}-${BUILD_TYPE}.apk"
EXPECTED_APK_DIR="build/app/outputs/flutter-apk"

echo "Building staging debug APK with flavor '${FLAVOR}'..."
# Explicitly specify the target file and pass Client ID
flutter build apk --debug --flavor "${FLAVOR}" -t lib/main_staging.dart \
  --dart-define=FLAVOR="${FLAVOR}" \
  --dart-define=CLIENT_ID="$MEMVERSE_CLIENT_ID"

echo "Searching for the generated APK: ${EXPECTED_APK_NAME}"
APK_PATH="${EXPECTED_APK_DIR}/${EXPECTED_APK_NAME}"

if [ ! -f "$APK_PATH" ]; then
    echo "ERROR: Could not find the expected debug APK at '${APK_PATH}'"
    exit 1
fi

echo "Found APK: $APK_PATH"
echo "Attempting to install APK to connected device/emulator..."

adb install -r "$APK_PATH"

echo "Checking installed version..."
adb shell dumpsys package com.spiritflightapps.memverse | grep versionName

echo "--------------------------------------------------"
echo "Process Complete!"
echo "--------------------------------------------------"
echo "Installation command finished."
echo "Check your connected device for the '[STG] Memverse' app (name defined in build.gradle)."
echo "Verify the version in Android Settings -> Apps -> [STG] Memverse."
echo "The version should be: ${EXPECTED_VERSION_STRING}"
echo "--------------------------------------------------"