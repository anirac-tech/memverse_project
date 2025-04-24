#!/bin/bash

# Source common utilities
# shellcheck source=./_common_build_utils.sh
source "$(dirname "${BASH_SOURCE[0]}")/_common_build_utils.sh"

# Change to project root
change_to_project_root

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

# Get version info from common utils
get_version_info

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

# Create a unique tag locally for this specific build
TAG_NAME="staging-v${VERSION}-${GIT_HASH}"
echo "Creating local Git tag: ${TAG_NAME}"
git tag -f "${TAG_NAME}"

echo "Checking installed version..."
adb shell dumpsys package com.spiritflightapps.memverse | grep versionName

echo "--------------------------------------------------"
echo "Verify the version in Android Settings -> Apps -> [STG] Memverse."
echo "The version should be: ${EXPECTED_VERSION_STRING}"
echo "--------------------------------------------------"

# Open the specific tag in GitHub (will 404 until pushed)
GITHUB_URL="https://github.com/anirac-tech/memverse_project/releases/tag/${TAG_NAME}"
echo "Opening GitHub tag page for this build: ${GITHUB_URL}"
echo "NOTE: This URL will show a 404 error until the tag is pushed."
open -a "Google Chrome" "${GITHUB_URL}"

echo "--------------------------------------------------"
echo "IMPORTANT: Tag '${TAG_NAME}' was created locally."
echo "To make the GitHub link work and share the tag, push it manually:"
echo "git push origin ${TAG_NAME}"
echo "--------------------------------------------------"

echo "Script finished."