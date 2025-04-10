#!/bin/bash

# Exit on error
set -e

# Load shared project configuration
source "$(dirname "$0")/project_config.sh"

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration values
ACCEPTABLE_COVERAGE_VALUES=("100.0%" "${MIN_COVERAGE}%")

# Print section header
print_header() {
  echo -e "\n${BLUE}==== $1 ====${NC}"
}

# Print success
print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

# Print error
print_error() {
  echo -e "${RED}✗ $1${NC}"
}

# Print info
print_info() {
  echo -e "${YELLOW}➤ $1${NC}"
}

# Check if a command exists
check_command() {
  if ! command -v $1 &> /dev/null; then
    print_error "$1 is not installed."
    exit 1
  fi
}

# Check dependencies
print_header "CHECKING DEPENDENCIES"
check_command flutter
check_command dart
print_success "All dependencies found"

# Check Flutter version
print_info "Flutter version:"
flutter --version

# Format code
print_header "FORMATTING CODE"
print_info "Running dart format..."
dart format --line-length 100 --set-exit-if-changed lib/src test
print_success "Code formatting is correct"

# Analyze code
print_header "ANALYZING CODE"
print_info "Running flutter analyze..."
flutter analyze lib test
print_success "No analysis issues found"

# Fix code
print_header "APPLYING DARTFIX"
print_info "Running dart fix..."
dart fix --apply
print_success "Applied dart fixes"

# Get dependencies
print_header "GETTING DEPENDENCIES"
print_info "Running flutter pub get..."
flutter pub get
print_success "Dependencies updated"

# Run tests with coverage
print_header "RUNNING TESTS"
print_info "Running flutter test with coverage..."
flutter test --coverage

# Process coverage
print_info "Processing coverage data..."
lcov --ignore-errors unused --remove coverage/lcov.info 'lib/l10n/*' 'test/verse_repository_test.mocks.dart' 'lib/src/features/auth/*' 'lib/src/bootstrap.dart' -o coverage/new_lcov.info
genhtml coverage/new_lcov.info -o coverage/html

# Calculate coverage percentage - simpler approach
COVERAGE_LINE=$(lcov --summary coverage/new_lcov.info | grep "lines" | sed 's/.*lines.......: \([0-9.]*%\).*/\1/')
print_info "Coverage: ${COVERAGE_LINE}"

# Check if coverage is in the list of acceptable values
coverage_is_acceptable=false
for value in "${ACCEPTABLE_COVERAGE_VALUES[@]}"; do
  if [[ "${COVERAGE_LINE}" == "${value}" ]]; then
    coverage_is_acceptable=true
    break
  fi
done

if [[ "${coverage_is_acceptable}" == "true" ]]; then
  print_success "Coverage is acceptable: ${COVERAGE_LINE}"
else
  print_error "Coverage is below acceptable levels: ${COVERAGE_LINE}"
  echo "See coverage report at: $(pwd)/coverage/html/index.html"
  # Add info on acceptable values
  echo "Acceptable coverage values are: ${ACCEPTABLE_COVERAGE_VALUES[*]}"
  exit 1
fi

print_header "ALL CHECKS PASSED"
print_info "Your code is ready to be committed!"