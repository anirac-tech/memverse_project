#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
FLAVOR="staging" # Default flavor for releases
INCREMENT_VALUE=10
PUBSPEC_FILE="pubspec.yaml"
# Use /tmp for temporary file for message construction, $$ makes it unique per execution
TEMP_NOTES_FILE_BASE="/tmp/memverse_release_notes.$$"
REQUIRED_ENV_VAR="MEMVERSE_CLIENT_ID" # Environment variable needed for the build
RELEASE_NOTES_DEFAULT_PATH="RELEASE_NOTES.md" # Default file for release notes

# --- Flags ---
DRY_RUN=false
AUTO_RUN=false

# --- Functions ---
usage() {
  echo "Usage: $0 [--flavor <flavor>] [--dry-run] [--auto] [-h|--help]"
  echo ""
  echo "Creates a new release build (AAB and APK) for the specified flavor."
  echo ""
  echo "Options:"
  echo "  --flavor <name>   Specify the build flavor (default: staging). Common values: development, staging, production."
  echo "  --dry-run         Show what commands would be executed without performing any actions."
  echo "  --auto            Run non-interactively, skipping the final confirmation prompt and using defaults for inputs."
  echo "  -h, --help        Display this help message and exit."
  echo ""
  echo "Default Behavior (no flags):"
  echo "  Shows planned actions (dry run), then asks for confirmation before proceeding."
  exit 0
}

get_current_version() {
  grep '^version:' "$PUBSPEC_FILE" | awk '{print $2}'
}

get_version_base() {
  echo "$1" | cut -d'+' -f1 | cut -d' ' -f1
}

get_build_number() {
  # Expects format like SEMVER+BUILD.HASH or SEMVER+BUILD
  local build_metadata
  build_metadata=$(echo "$1" | cut -d'+' -f2)
  # Get the part before the first dot (if any)
  echo "$build_metadata" | cut -d'.' -f1
}

get_commit_hash() {
  git rev-parse --short HEAD
}

# Function to execute commands or print them for dry run
run_command() {
  if [ "$DRY_RUN" = true ]; then
    # Use printf with %q for safe display of arguments
    printf "DRY RUN: Would execute:"
    printf " %q" "$@" # Print each argument quoted
    printf "\n"
  else
    # Execute the command directly. Output will be shown by the command itself.
    "$@"
  fi
}

# Cleanup function for temporary files
cleanup() {
  # Remove the temp files if they exist (used for -F option)
  rm -f "${TEMP_NOTES_FILE_BASE}.commit.txt" "${TEMP_NOTES_FILE_BASE}.tag.txt"
}
# Register cleanup function to run on EXIT signal (normal exit or error)
trap cleanup EXIT

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --flavor)
      FLAVOR="$2"
      shift # past argument
      shift # past value
      ;;
    --dry-run)
      DRY_RUN=true
      shift # past argument
      ;;
    --auto)
      AUTO_RUN=true
      shift # past argument
      ;;
    -h|--help)
      usage
      ;;
    *)    # unknown option
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# If --auto and --dry-run are both set, dry-run takes precedence
if [ "$AUTO_RUN" = true ] && [ "$DRY_RUN" = true ]; then
    echo "Info: --dry-run specified, ignoring --auto."
    AUTO_RUN=false
fi

# Determine if we need confirmation (default behavior: no flags)
# Confirmation is needed if NOT in dry-run AND NOT in auto mode.
NEEDS_CONFIRMATION=false
if [ "$DRY_RUN" = false ] && [ "$AUTO_RUN" = false ]; then
    NEEDS_CONFIRMATION=true
fi

# --- Main Script ---

echo "Starting Android release process for flavor: $FLAVOR..."
if [ "$DRY_RUN" = true ]; then
    echo "*** DRY RUN MODE ENABLED ***"
fi
if [ "$AUTO_RUN" = true ]; then
    echo "*** AUTO RUN MODE ENABLED (will skip confirmation and use defaults) ***"
fi

# 0. Check for required environment variable
echo "Checking for environment variable '$REQUIRED_ENV_VAR'..."
if [[ -z "${!REQUIRED_ENV_VAR}" ]]; then
    if [ "$DRY_RUN" = true ]; then
        echo "DRY RUN: Would check for required environment variable '$REQUIRED_ENV_VAR' (not set)."
    else
        echo "Error: Required environment variable '$REQUIRED_ENV_VAR' is not set."
        echo "Please set it before running this script (refer to setup.md)."
        exit 1
    fi
else
    echo "Required environment variable '$REQUIRED_ENV_VAR' found."
fi

# 1. Ensure clean git state
echo "Checking Git status..."
if ! git diff --quiet HEAD; then
  if [ "$DRY_RUN" = true ]; then
      echo "DRY RUN: Would check for clean Git status (found uncommitted changes)."
  else
      echo "Error: Your Git working directory is not clean. Please commit or stash changes."
      exit 1
  fi
else
    echo "Git status clean."
fi

# 2. Get commit hash
COMMIT_HASH=$(get_commit_hash)
echo "Current short commit hash: $COMMIT_HASH"

# 3. Get current version info
CURRENT_VERSION=$(get_current_version)
CURRENT_VERSION_BASE=$(get_version_base "$CURRENT_VERSION")
CURRENT_BUILD_NUMBER=$(get_build_number "$CURRENT_VERSION")

echo "Current version: $CURRENT_VERSION (Base: $CURRENT_VERSION_BASE, Build: $CURRENT_BUILD_NUMBER)"

# 4. Determine new semantic version
if [ "$AUTO_RUN" = true ]; then
    NEW_SEMANTIC_VERSION=$CURRENT_VERSION_BASE # Use current in auto mode
    echo "Using current semantic version for --auto run: $NEW_SEMANTIC_VERSION"
elif [ "$DRY_RUN" = true ]; then # Pure dry run also uses current
    NEW_SEMANTIC_VERSION=$CURRENT_VERSION_BASE
    echo "DRY RUN: Using current semantic version: $NEW_SEMANTIC_VERSION"
else # Interactive mode (default or explicit confirmation)
    read -p "Enter the new semantic version (e.g., 1.2.4, default: $CURRENT_VERSION_BASE): " NEW_SEMANTIC_VERSION
    # Default to current if user just presses Enter
    NEW_SEMANTIC_VERSION=${NEW_SEMANTIC_VERSION:-$CURRENT_VERSION_BASE}
    # Validate (basic check for non-empty)
    if [[ -z "$NEW_SEMANTIC_VERSION" ]]; then
        echo "Error: Semantic version cannot be empty."
        exit 1
    fi
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
NEW_VERSION_STRING="$NEW_SEMANTIC_VERSION+$NEW_BUILD_NUMBER.$COMMIT_HASH"
echo "New version string: $NEW_VERSION_STRING"

# 7. Determine Release Notes
RELEASE_NOTES_CONTENT=""
NOTES_SOURCE=""
if [ "$AUTO_RUN" = true ]; then
    RELEASE_NOTES_CONTENT="Auto-release for v$NEW_VERSION_STRING"
    NOTES_SOURCE="auto-generated"
    echo "Using automatic release notes for --auto run."
elif [ "$DRY_RUN" = true ]; then # Pure dry run uses placeholder
    RELEASE_NOTES_CONTENT="Dry run release notes for v$NEW_VERSION_STRING"
    NOTES_SOURCE="dry-run placeholder"
    echo "DRY RUN: Using placeholder release notes."
else # Interactive mode (default or explicit confirmation) - Now uses default file
    echo "Checking for release notes file: $RELEASE_NOTES_DEFAULT_PATH" 
    if [ ! -f "$RELEASE_NOTES_DEFAULT_PATH" ]; then
        echo "Release notes file not found. Creating default: $RELEASE_NOTES_DEFAULT_PATH"
        # Create the file with the specified default content
        echo "Initial live reference quiz barebones MVP with known one-off error bug at end of list" > "$RELEASE_NOTES_DEFAULT_PATH"
        RELEASE_NOTES_CONTENT=$(cat "$RELEASE_NOTES_DEFAULT_PATH")
        NOTES_SOURCE="created default file"
    else
        echo "Reading release notes from: $RELEASE_NOTES_DEFAULT_PATH"
        RELEASE_NOTES_CONTENT=$(cat "$RELEASE_NOTES_DEFAULT_PATH")
        NOTES_SOURCE="existing default file"
        if [[ -z "$RELEASE_NOTES_CONTENT" ]]; then
            echo "Warning: $RELEASE_NOTES_DEFAULT_PATH is empty."
            # Provide default content if file is empty
            RELEASE_NOTES_CONTENT="(Release notes file '$RELEASE_NOTES_DEFAULT_PATH' was empty for v$NEW_VERSION_STRING)"
            NOTES_SOURCE="empty default file"
        fi
    fi
    echo "Using release notes from $NOTES_SOURCE."
fi

# Construct Tag Name
TAG_NAME="v$NEW_SEMANTIC_VERSION+$NEW_BUILD_NUMBER-$FLAVOR"

# --- List Actions Planned --- (Always shown, acts as dry run for default mode)
echo ""
echo "--- Planned Actions ---"
echo "1. Update $PUBSPEC_FILE to version: $NEW_VERSION_STRING"
echo "2. Commit version update with message: chore: Bump version for $FLAVOR release $NEW_VERSION_STRING"
echo "3. Create annotated Git tag: $TAG_NAME"
echo "4. Push commit and tag to origin (DISABLED - manual push required)"
echo "5. Run flutter clean"
echo "6. Build $FLAVOR Android App Bundle (AAB)"
echo "7. Build $FLAVOR Android APK"
echo "---------------------"

# --- Confirmation (if needed) ---
if [ "$NEEDS_CONFIRMATION" = true ]; then
  read -p "Do you want to proceed with these actions? [Y/n]: " confirm
  confirm=${confirm:-Y} # Default to Yes
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "Aborting."
      exit 1 # Cleanup trap will run
  fi
  echo "Proceeding..."
fi

# --- Execute Actions (if not dry run) ---

# Action 1: Update pubspec.yaml
if [ "$DRY_RUN" = false ]; then
    echo "Updating $PUBSPEC_FILE..."
fi
run_command sed -i '' "s/^version: .*/version: $NEW_VERSION_STRING/" "$PUBSPEC_FILE"
if [ "$DRY_RUN" = false ]; then
    echo "$PUBSPEC_FILE updated."
fi

# Action 2: Commit version change
COMMIT_MSG_TITLE="chore: Bump version for $FLAVOR release $NEW_VERSION_STRING"
if [ "$DRY_RUN" = false ]; then
    echo "Committing version update..."
fi
run_command git add "$PUBSPEC_FILE"
# Use -m for short auto/dry-run notes, or -F using the fetched/default content
if [ "$NOTES_SOURCE" = "auto-generated" ] || [ "$NOTES_SOURCE" = "dry-run placeholder" ] || [ "$NOTES_SOURCE" = "empty default file" ]; then
    # Use double -m for title and body (body might be placeholder)
    run_command git commit --no-verify -m "$COMMIT_MSG_TITLE" -m "$RELEASE_NOTES_CONTENT"
else
    # Prepend title to the notes content for use with -F
    COMMIT_MSG_FILE="${TEMP_NOTES_FILE_BASE}.commit.txt"
    if [ "$DRY_RUN" = false ]; then
        echo "$COMMIT_MSG_TITLE" > "$COMMIT_MSG_FILE"
        echo "" >> "$COMMIT_MSG_FILE" # Add a blank line
        echo "$RELEASE_NOTES_CONTENT" >> "$COMMIT_MSG_FILE"
        run_command git commit --no-verify -F "$COMMIT_MSG_FILE"
    else
        # Dry run just indicates it would use -F
        run_command git commit --no-verify -F "(Generated file from $RELEASE_NOTES_DEFAULT_PATH with title prepended)"
    fi
fi

# Action 3: Create Git tag
TAG_MSG_TITLE="Release $FLAVOR $NEW_VERSION_STRING"
if [ "$DRY_RUN" = false ]; then
    echo "Creating annotated Git tag: $TAG_NAME"
fi
# Use -m for short auto/dry-run notes, or -F using the fetched/default content
if [ "$NOTES_SOURCE" = "auto-generated" ] || [ "$NOTES_SOURCE" = "dry-run placeholder" ] || [ "$NOTES_SOURCE" = "empty default file" ]; then
    # Use double -m for title and body (body might be placeholder)
    run_command git tag -a "$TAG_NAME" -m "$TAG_MSG_TITLE" -m "$RELEASE_NOTES_CONTENT"
else
    # Prepend title to the notes content for use with -F
    TAG_MSG_FILE="${TEMP_NOTES_FILE_BASE}.tag.txt"
    if [ "$DRY_RUN" = false ]; then
        echo "$TAG_MSG_TITLE" > "$TAG_MSG_FILE"
        echo "" >> "$TAG_MSG_FILE" # Add a blank line
        echo "$RELEASE_NOTES_CONTENT" >> "$TAG_MSG_FILE"
        run_command git tag -a "$TAG_NAME" -F "$TAG_MSG_FILE"
    else
        # Dry run just indicates it would use -F
        run_command git tag -a "$TAG_NAME" -F "(Generated file from $RELEASE_NOTES_DEFAULT_PATH with title prepended)"
    fi
fi

# Action 4: Push commit and tag (DISABLED BY DEFAULT)
if [ "$DRY_RUN" = false ]; then
    echo "Pushing commit and tag to origin... (DISABLED)"
fi
# NOTE: Pushing is disabled by default due to potential Git authentication issues (e.g., HTTPS password auth deprecation).
#       Configure Git with a Personal Access Token (PAT) or SSH key for authentication.
#       See: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens
#       See: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
#
#       To re-enable automatic push, uncomment the following two lines.
#       Alternatively, push manually after the script completes:
#       git push origin HEAD
#       git push origin "$TAG_NAME"
# run_command git push origin HEAD
# run_command git push origin "$TAG_NAME"

# Action 5: Clean
if [ "$DRY_RUN" = false ]; then
    echo "Running flutter clean..."
fi
run_command flutter clean

# Action 6: Build AAB
if [ "$DRY_RUN" = false ]; then
    echo "Building $FLAVOR Android App Bundle (AAB)..."
fi
run_command flutter build appbundle --release --flavor "$FLAVOR" --target "lib/main_$FLAVOR.dart" --build-name="$NEW_SEMANTIC_VERSION" --build-number="$NEW_BUILD_NUMBER" --dart-define=CLIENT_ID="${!REQUIRED_ENV_VAR}"

# Action 7: Build APK
if [ "$DRY_RUN" = false ]; then
    echo "Building $FLAVOR Android APK..."
fi
run_command flutter build apk --release --flavor "$FLAVOR" --target "lib/main_$FLAVOR.dart" --build-name="$NEW_SEMANTIC_VERSION" --build-number="$NEW_BUILD_NUMBER" --dart-define=CLIENT_ID="${!REQUIRED_ENV_VAR}"

# --- Post-Build Instructions / Dry Run Summary ---
FLAVOR_UPPER=$(echo "$FLAVOR" | tr '[:lower:]' '[:upper:]')
# Define paths even for dry run for consistency
AAB_PATH="build/app/outputs/bundle/${FLAVOR}Release/app-$FLAVOR-release.aab"
APK_PATH="build/app/outputs/flutter-apk/app-$FLAVOR-release.apk"

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "*** DRY RUN COMPLETE ***"
  echo "No actual changes were made."
else
  echo ""
  echo "-------------------------------------"
  echo " $FLAVOR_UPPER Release Build Complete! (Local Only)"
  echo " Version: $NEW_VERSION_STRING"
  echo " Tag: $TAG_NAME (Created locally)"
  echo " Flavor: $FLAVOR"
  echo "-------------------------------------"
  echo ""
  echo "*** IMPORTANT: Commit and Tag were NOT pushed automatically. ***"
  echo "    Reason: Automatic push is disabled due to potential Git authentication issues."
  echo "    Action Required: Manually push the commit and tag:"
  echo "      git push origin HEAD"
  echo "      git push origin $TAG_NAME"
  echo "    (Ensure your Git client is authenticated with GitHub using a PAT or SSH key.)"
  echo ""
  echo "Build outputs:"
  echo "  AAB: $AAB_PATH"
  echo "  APK: $APK_PATH"
  echo ""
  echo "Next Steps:"
  echo "1. Manually upload '$AAB_PATH' to Firebase App Distribution."
  echo "   - Go to Firebase Console -> App Distribution."
  echo "   - Select your Android app (ensure it's configured for the $FLAVOR flavor if necessary)."
  echo "   - Drag & drop the AAB file."
  echo "   - Add testers/groups."
  echo "   - **Copy the release notes entered (or generated for --auto) into the Firebase release notes field.**"
  echo "   -   (Release notes are in the commit/tag message for $TAG_NAME)"
  echo "   - Distribute."
  echo ""
  echo "2. (Optional) Distribute via Firebase CLI:"
  # Use the actual release notes content variable, checking it's not the placeholder
  if [ -n "$RELEASE_NOTES_CONTENT" ] && [[ ! "$RELEASE_NOTES_CONTENT" =~ ^\(No\ release\ notes\ provided ]]; then
      # Escape quotes for shell command line
      ESCAPED_NOTES=$(echo "$RELEASE_NOTES_CONTENT" | sed 's/"/\\"/g')
      printf "   firebase appdistribution:distribute %s \\\n" "$AAB_PATH"
      printf "       --app <YOUR_FIREBASE_APP_ID> \\\n"
      printf "       --release-notes \"%s\" \\\n" "$ESCAPED_NOTES"
      printf "       --groups \"<your-group-alias>\"\n"
  else
      echo "   (Skipping Firebase CLI example as release notes were empty or placeholders)"
  fi
  echo ""
  echo "3. (Optional) Share the APK ('$APK_PATH') via other methods if needed (e.g., Google Drive, direct install)."
  echo ""
  echo "   - **Ensure the release notes from '$RELEASE_NOTES_DEFAULT_PATH' (also in commit/tag $TAG_NAME) are appropriate for Firebase.**"
fi