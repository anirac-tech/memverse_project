
# Minimum test coverage percentage required (used by pre-commit hook)
export MIN_COVERAGE_WIDGET=81
export MIN_COVERAGE_INTEGRATION=81

# Excluded files/directories from coverage calculation
# Space-separated list of glob patterns
export COVERAGE_EXCLUDES="lib/l10n/**/* **/*.g.dart **/*.freezed.dart lib/src/bootstrap.dart lib/src/app/app.dart lib/src/app/view/app.dart **/generated/**/* **/generated_plugin_registrant.dart"

# Flutter version requirement (should match pubspec.yaml)
export FLUTTER_VERSION="3.29.3"

# Golden test configuration
# Setting this to "true" will make the pre-commit hook fail if golden tests fail
export GOLDEN_TESTS_STRICT="false"

# Function to check version requirements
check_version() {
  local current_version=$1
  local required_version=$2
  
  # Split versions into components
  IFS='.' read -ra CURRENT <<< "$current_version"
  IFS='.' read -ra REQUIRED <<< "$required_version"
  
  # Compare each component
  for i in "${!REQUIRED[@]}"; do
    if [[ ${CURRENT[$i]} -lt ${REQUIRED[$i]} ]]; then
      return 1
    elif [[ ${CURRENT[$i]} -gt ${REQUIRED[$i]} ]]; then
      return 0
    fi
  done
  
  return 0
}