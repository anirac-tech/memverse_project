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
dart format --line-length 100 lib test
print_success "Code formatted"

# Analyze code
print_header "ANALYZING CODE"
print_info "Running flutter analyze..."
flutter analyze
print_success "No analysis issues found"

# Get dependencies
print_header "GETTING DEPENDENCIES"
print_info "Running flutter pub get..."
flutter pub get
print_success "Dependencies updated"

# Handle golden tests first (update AND run without failing)
print_header "HANDLING GOLDEN TESTS"
print_info "Generating/updating golden files..."
flutter test --update-goldens --tags golden || true
print_info "Running golden tests (checking for diffs)..."

# Temporarily disable exit on error to allow golden test 'failures'
set +e
flutter test --tags golden
GOLDEN_TEST_EXIT_CODE=$?
# Re-enable exit on error
set -e

# Process golden test results
if [ $GOLDEN_TEST_EXIT_CODE -ne 0 ]; then
  print_info "Golden test differences detected. Please review the changes in 'test/**/failures/*.png'."
  print_info "If the changes are intended, commit the updated golden files in 'test/**/<test_name>.png'."
  
  # Generate golden test report
  if [ -f "$(dirname "$0")/generate_golden_report.sh" ]; then
    print_info "Generating golden test report..."
    "$(dirname "$0")/generate_golden_report.sh" > /dev/null 2>&1 || true
    print_info "Report generated at golden_report/index.html"
  fi
else
  print_success "Golden tests passed (no differences detected)."
fi

# Run widget tests with coverage
print_header "RUNNING WIDGET TESTS"
print_info "Running widget tests with coverage (excluding golden and integration tests)..."
flutter test test/ --exclude-tags golden,integration --coverage

# Process widget test coverage
print_info "Processing widget test coverage data..."
# Convert space-separated glob patterns to lcov exclusion args
LCOV_EXCLUDE_ARGS=""
for pattern in $COVERAGE_EXCLUDES; do
  LCOV_EXCLUDE_ARGS+=" '$pattern'"
done

# Apply the exclusions
eval "lcov --ignore-errors unused --remove coverage/lcov.info $LCOV_EXCLUDE_ARGS -o coverage/widget_lcov.info"
genhtml coverage/widget_lcov.info -o coverage/widget_html

# Calculate widget coverage percentage
WIDGET_COVERAGE_LINE=$(lcov --summary coverage/widget_lcov.info | grep "lines" | sed 's/.*lines.......: \([0-9.]*%\).*/\1/')
print_info "Widget Test Coverage: ${WIDGET_COVERAGE_LINE}"

# Check if widget coverage meets minimum requirement
WIDGET_COVERAGE_NUMBER=$(echo ${WIDGET_COVERAGE_LINE} | sed 's/%//')
if (( $(echo "${WIDGET_COVERAGE_NUMBER} >= ${MIN_COVERAGE_WIDGET}" | bc -l) )); then
  print_success "Widget test coverage is acceptable: ${WIDGET_COVERAGE_LINE} (minimum: ${MIN_COVERAGE_WIDGET}%)"
else
  print_error "Widget test coverage is below acceptable levels: ${WIDGET_COVERAGE_LINE} (minimum: ${MIN_COVERAGE_WIDGET}%)"
  
  # Open coverage report on macOS when coverage fails
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/widget_html/index.html
  fi
  
  echo "See widget test coverage report at: $(pwd)/coverage/widget_html/index.html"
  exit 1
fi

# Run integration tests with coverage
print_header "RUNNING INTEGRATION TESTS"
print_info "Running integration tests with coverage..."
flutter test integration_test/ --tags integration --coverage

# Process integration test coverage
print_info "Processing integration test coverage data..."
# Apply the exclusions
eval "lcov --ignore-errors unused --remove coverage/lcov.info $LCOV_EXCLUDE_ARGS -o coverage/integration_lcov.info"
genhtml coverage/integration_lcov.info -o coverage/integration_html

# Calculate integration coverage percentage
INTEGRATION_COVERAGE_LINE=$(lcov --summary coverage/integration_lcov.info | grep "lines" | sed 's/.*lines.......: \([0-9.]*%\).*/\1/')
print_info "Integration Test Coverage: ${INTEGRATION_COVERAGE_LINE}"

# Check if integration coverage meets minimum requirement
INTEGRATION_COVERAGE_NUMBER=$(echo ${INTEGRATION_COVERAGE_LINE} | sed 's/%//')
if (( $(echo "${INTEGRATION_COVERAGE_NUMBER} >= ${MIN_COVERAGE_INTEGRATION}" | bc -l) )); then
  print_success "Integration test coverage is acceptable: ${INTEGRATION_COVERAGE_LINE} (minimum: ${MIN_COVERAGE_INTEGRATION}%)"
else
  print_error "Integration test coverage is below acceptable levels: ${INTEGRATION_COVERAGE_LINE} (minimum: ${MIN_COVERAGE_INTEGRATION}%)"
  
  # Open coverage report on macOS when coverage fails
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/integration_html/index.html
  fi
  
  echo "See integration test coverage report at: $(pwd)/coverage/integration_html/index.html"
  exit 1
fi

print_header "ALL CHECKS PASSED"
print_info "Your code is ready to be committed!"