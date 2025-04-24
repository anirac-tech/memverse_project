#!/bin/bash

# Common utilities for Android build scripts

# Get the directory where the calling script is located
# Assumes this is sourced from a script in scripts/android/
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" &> /dev/null && pwd )"
# Navigate two levels up to the project root
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

# Function to change to project root
change_to_project_root() {
  echo "Changing directory to project root: $PROJECT_ROOT"
  cd "$PROJECT_ROOT"
}

# Function to get version info
get_version_info() {
  echo "Getting version info..."
  VERSION=$(grep 'version:' pubspec.yaml | cut -d ' ' -f 2 | cut -d '+' -f 1)
  GIT_HASH=$(git rev-parse --short HEAD)
  EXPECTED_VERSION_STRING="${VERSION}+${GIT_HASH}"
  # Export variables so they are available in the calling script
  export VERSION
  export GIT_HASH
  export EXPECTED_VERSION_STRING
}
