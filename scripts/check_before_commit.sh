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
check_command lcov
check_command genhtml
print_success "All dependencies found"

# Check Flutter version
print_info "Flutter version:"
flutter --version

# Fix code first (before formatting)
print_header "APPLYING DARTFIX"
print_info "Running dart fix..."
dart fix --apply
print_success "Applied dart fixes"

# Format code after fixes
print_header "FORMATTING CODE"
print_info "Running dart format..."
dart format --line-length 100 lib/src test
print_success "Code formatted"

# Analyze code
print_header "ANALYZING CODE"
print_info "Running flutter analyze..."
flutter analyze lib test
print_success "No analysis issues found"

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
# Using exclusions from project_config.sh
for exclude in $COVERAGE_EXCLUDES; do
  EXCLUDE_ARGS="${EXCLUDE_ARGS} '${exclude}'"
done
eval "lcov --rc lcov_branch=1 --ignore-errors unused --remove coverage/lcov.info ${EXCLUDE_ARGS} -o coverage/new_lcov.info"
genhtml coverage/new_lcov.info --branch-coverage -o coverage/html

# Print detailed coverage report
print_header "DETAILED COVERAGE"
eval "lcov --rc lcov_branch=1 --list coverage/new_lcov.info"

# Calculate coverage percentage
LINE_COVERAGE=$(lcov --summary coverage/new_lcov.info | grep "lines" | sed 's/.*lines.......: \([0-9.]*%\).*/\1/')
FUNCTION_COVERAGE=$(lcov --summary coverage/new_lcov.info | grep "functions" | sed 's/.*functions...: \([0-9.]*%\).*/\1/' || echo "N/A")
BRANCH_COVERAGE=$(lcov --summary coverage/new_lcov.info | grep "branches" | sed 's/.*branches....: \([0-9.]*%\).*/\1/' || echo "N/A")

print_info "Line Coverage: ${LINE_COVERAGE}"
print_info "Function Coverage: ${FUNCTION_COVERAGE}"
print_info "Branch Coverage: ${BRANCH_COVERAGE}"

# Extract just the number from the coverage percentage for comparison
COVERAGE_NUMBER=$(echo ${LINE_COVERAGE} | sed 's/%//')
# Ensure MIN_COVERAGE is treated as a number (removes potential quotes)
MIN_COVERAGE_NUM=$(echo ${MIN_COVERAGE} | tr -d \'\")

# Check if coverage meets minimum requirement using bc for floating point comparison
if (( $(echo "${COVERAGE_NUMBER} >= ${MIN_COVERAGE_NUM}" | bc -l) )); then
  print_success "Coverage is acceptable: ${LINE_COVERAGE} (minimum: ${MIN_COVERAGE_NUM}%)"
else
  print_error "Coverage is BELOW acceptable levels: ${LINE_COVERAGE} (minimum: ${MIN_COVERAGE_NUM}%)"
  echo "See coverage report at: $(pwd)/coverage/html/index.html"

  # Always open coverage report at the end on failure
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/html/index.html
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v xdg-open &> /dev/null; then
      xdg-open coverage/html/index.html
    fi
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    start coverage/html/index.html
  fi
  
  exit 1
fi

# Always open coverage report at the end (even if passing)
if [[ "$OSTYPE" == "darwin"* ]]; then
  open coverage/html/index.html
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v xdg-open &> /dev/null; then
    xdg-open coverage/html/index.html
  fi
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
  start coverage/html/index.html
fi

print_header "ALL CHECKS PASSED"
print_info "Your code is ready to be committed!"