#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
INCREMENT_VALUE=10
PUBSPEC_FILE="pubspec.yaml"
RELEASE_NOTES_FILE="release_notes.txt" # Temporary file for release notes

# --- Functions ---
get_current_version() {
  grep '^version:' "$PUBSPEC_FILE" | awk '{print $2}'
}

get_version_base() {
  echo "$1" | cut -d'+' -f1 | cut -d' ' -f1
}

get_build_number() {
  echo "$1" | cut -d'+' -f2
}

get_commit_hash() {
  git rev-parse --short HEAD
}

# --- Main Script ---

echo "Starting Android release process..."

# 1. Ensure clean git state
if ! git diff --quiet HEAD; then
  echo "Error: Your Git working directory is not clean. Please commit or stash changes."
  exit 1
fi
echo "Git status clean."

# 2. Get commit hash
COMMIT_HASH=$(get_commit_hash)
echo "Current short commit hash: $COMMIT_HASH"

# 3. Get current version info
CURRENT_VERSION=$(get_current_version)
CURRENT_VERSION_BASE=$(get_version_base "$CURRENT_VERSION")
CURRENT_BUILD_NUMBER=$(get_build_number "$CURRENT_VERSION")

echo "Current version: $CURRENT_VERSION (Base: $CURRENT_VERSION_BASE, Build: $CURRENT_BUILD_NUMBER)"

# 4. Prompt for new semantic version
read -p "Enter the new semantic version (e.g., 1.2.4, current is $CURRENT_VERSION_BASE): " NEW_SEMANTIC_VERSION

if [[ -z "$NEW_SEMANTIC_VERSION" ]]; then
  echo "Error: Semantic version cannot be empty."
  exit 1
fi

# 5. Calculate new build number
if [[ -z "$CURRENT_BUILD_NUMBER" || ! "$CURRENT_BUILD_NUMBER" =~ ^[0-9]+$ ]]; then
    echo "Warning: Could not parse current build number from '$CURRENT_VERSION'. Starting from $INCREMENT_VALUE."
    NEW_BUILD_NUMBER=$INCREMENT_VALUE
else
    NEW_BUILD_NUMBER=$((CURRENT_BUILD_NUMBER + INCREMENT_VALUE))
fi
echo "New build number: $NEW_BUILD_NUMBER"

# 6. Construct new version string
NEW_VERSION_STRING="$NEW_SEMANTIC_VERSION ($COMMIT_HASH)+$NEW_BUILD_NUMBER"
echo "New version string: $NEW_VERSION_STRING"

# 7. Update pubspec.yaml
echo "Updating $PUBSPEC_FILE..."
# Use sed -i for in-place editing. The '' is for macOS compatibility (no backup file).
sed -i '' "s/^version: .*/version: $NEW_VERSION_STRING/" "$PUBSPEC_FILE"
echo "$PUBSPEC_FILE updated."

# 8. Prompt for release notes
echo "Please enter release notes (end with Ctrl+D):"
cat > "$RELEASE_NOTES_FILE"
RELEASE_NOTES_CONTENT=$(cat "$RELEASE_NOTES_FILE")
if [[ -z "$RELEASE_NOTES_CONTENT" ]]; then
    echo "Warning: Release notes are empty."
fi

# 9. Commit version change
echo "Committing version update..."
git add "$PUBSPEC_FILE"
git commit -m "chore: Bump version for release v$NEW_VERSION_STRING" -m "$RELEASE_NOTES_CONTENT"

# 10. Create Git tag
TAG_NAME="v$NEW_SEMANTIC_VERSION+$NEW_BUILD_NUMBER"
echo "Creating annotated Git tag: $TAG_NAME"
git tag -a "$TAG_NAME" -m "Release $NEW_VERSION_STRING" -m "$RELEASE_NOTES_CONTENT"

# 11. Push commit and tag
echo "Pushing commit and tag to origin..."
git push origin HEAD
git push origin "$TAG_NAME"

# 12. Clean and Build
echo "Running flutter clean..."
flutter clean
echo "Building Android App Bundle (AAB)..."
flutter build appbundle --release --build-name="$NEW_SEMANTIC_VERSION ($COMMIT_HASH)" --build-number="$NEW_BUILD_NUMBER"
echo "Building Android APK..."
flutter build apk --release --build-name="$NEW_SEMANTIC_VERSION ($COMMIT_HASH)" --build-number="$NEW_BUILD_NUMBER"

# 13. Clean up temporary release notes file
rm "$RELEASE_NOTES_FILE"

# --- Post-Build Instructions ---
echo ""
echo "-------------------------------------"
echo " Release Build Complete!"
echo " Version: $NEW_VERSION_STRING"
echo " Tag: $TAG_NAME"
echo "-------------------------------------"
echo ""
echo "Build outputs:"
echo "  AAB: build/app/outputs/bundle/release/app-release.aab"
echo "  APK: build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "Next Steps:"
echo "1. Manually upload 'build/app/outputs/bundle/release/app-release.aab' to Firebase App Distribution."
echo "   - Go to Firebase Console -> App Distribution."
echo "   - Select your Android app."
echo "   - Drag & drop the AAB file."
echo "   - Add testers/groups."
echo "   - **Copy the release notes from the commit message or '$RELEASE_NOTES_FILE' (now deleted) into the Firebase release notes field.**"
echo "   - Distribute."
echo ""
echo "2. (Optional) Distribute via Firebase CLI:"
ESCAPED_NOTES=$(echo "$RELEASE_NOTES_CONTENT" | sed 's/"/\\"/g') # Escape quotes for shell
printf "   firebase appdistribution:distribute build/app/outputs/bundle/release/app-release.aab \\\n"
printf "       --app <YOUR_FIREBASE_APP_ID> \\\n"
printf "       --release-notes \"%s\" \\\n" "$ESCAPED_NOTES"
printf "       --groups \"<your-group-alias>\"\n"

echo ""
echo "3. (Optional) Share the APK ('build/app/outputs/flutter-apk/app-release.apk') via other methods if needed (e.g., Google Drive, direct install)."
echo ""