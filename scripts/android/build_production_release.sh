
# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Navigate two levels up to the project root
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

# Change to the project root directory
cd "$PROJECT_ROOT"

# Exit immediately if a command exits with a non-zero status.
set -e

FLAVOR="production"
BUILD_TYPE="release"

echo "--------------------------------------------------"
echo "Starting Production Release APK Creation Process"
echo "--------------------------------------------------"

# Get the current version and git hash
VERSION=$(grep 'version:' pubspec.yaml | cut -d ' ' -f 2 | cut -d '+' -f 1)
GIT_HASH=$(git rev-parse --short HEAD)
# Mimics the sanitized version name from build.gradle (replace '+' with '_')
SANITIZED_VERSION="${VERSION}_${GIT_HASH}"
EXPECTED_APK_BASE_NAME="memverse_${SANITIZED_VERSION}_${BUILD_TYPE}"
EXPECTED_APK_NAME="${EXPECTED_APK_BASE_NAME}.apk"
EXPECTED_APK_DIR="build/app/outputs/flutter-apk"

echo "Building production release APK with flavor '${FLAVOR}'..."
flutter build apk --release --flavor "${FLAVOR}" --dart-define=FLAVOR="${FLAVOR}"

echo "Searching for the generated APK: ${EXPECTED_APK_NAME}"
APK_PATH=$(find "${EXPECTED_APK_DIR}" -name "${EXPECTED_APK_NAME}" -print -quit)

if [ -z "$APK_PATH" ]; then
    echo "ERROR: Could not find the release APK matching pattern '${EXPECTED_APK_NAME}' in ${EXPECTED_APK_DIR}/"
    # Fallback search in case the exact name prediction was wrong
    echo "Attempting fallback search for any release apk in the flavor directory..."
    APK_PATH=$(find "${EXPECTED_APK_DIR}" -name "memverse_*_${BUILD_TYPE}.apk" -print -quit)
    if [ -z "$APK_PATH" ]; then
      echo "ERROR: Fallback search also failed. Could not find any release APK."
      exit 1
    else
      echo "WARNING: Found APK using fallback: $APK_PATH. Name might not exactly match expected pattern."
    fi
fi

echo "--------------------------------------------------"
echo "Process Complete!"
echo "--------------------------------------------------"
echo "Found Release APK at: ${APK_PATH}"
echo "This APK is signed using the release configuration."
echo "You can now upload it to the Play Store or distribute it."
echo "--------------------------------------------------"
