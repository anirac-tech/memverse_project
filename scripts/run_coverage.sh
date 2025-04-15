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

# Check dependencies
print_header "CHECKING DEPENDENCIES"
for cmd in flutter dart lcov genhtml; do
  if ! command -v $cmd &> /dev/null; then
    print_error "$cmd is not installed."
    exit 1
  fi
done
print_success "All dependencies found"

# Run tests with coverage
print_header "RUNNING TESTS WITH COVERAGE"
print_info "Running flutter test with coverage..."
flutter test --coverage

# Process coverage data
print_header "PROCESSING COVERAGE DATA"
print_info "Removing excluded files from coverage..."

# Start with a clean new_lcov.info
if [ -f coverage/new_lcov.info ]; then
  rm coverage/new_lcov.info
fi

# Using exclusions from project_config.sh
EXCLUDE_ARGS=""
for exclude in $COVERAGE_EXCLUDES; do
  EXCLUDE_ARGS="${EXCLUDE_ARGS} '${exclude}'"
done

# Remove excluded files from coverage
eval "lcov --rc lcov_branch=1 --ignore-errors unused --remove coverage/lcov.info ${EXCLUDE_ARGS} -o coverage/new_lcov.info"
print_success "Excluded files removed from coverage data"

# Generate HTML report
print_header "GENERATING HTML REPORT"
print_info "Creating HTML coverage report..."
genhtml coverage/new_lcov.info --branch-coverage -o coverage/html --dark-mode
print_success "HTML report generated at coverage/html/index.html"

# Calculate coverage metrics
print_header "COVERAGE METRICS"
print_info "Overall coverage statistics:"

# Parse coverage metrics
LINE_COVERAGE=$(lcov --summary coverage/new_lcov.info | grep "lines" | sed 's/.*lines.......: \([0-9.]*%\).*/\1/')
FUNCTION_COVERAGE=$(lcov --summary coverage/new_lcov.info | grep "functions" | sed 's/.*functions...: \([0-9.]*%\).*/\1/')
BRANCH_COVERAGE=$(lcov --summary coverage/new_lcov.info | grep "branches" | sed 's/.*branches....: \([0-9.]*%\).*/\1/' || echo "N/A")

echo -e "Line Coverage:     ${GREEN}${LINE_COVERAGE}${NC}"
echo -e "Function Coverage: ${GREEN}${FUNCTION_COVERAGE}${NC}"
echo -e "Branch Coverage:   ${GREEN}${BRANCH_COVERAGE}${NC}"

# Evaluate against minimum requirements
COVERAGE_NUMBER=$(echo ${LINE_COVERAGE} | sed 's/%//')

print_header "COVERAGE EVALUATION"
if (( $(echo "${COVERAGE_NUMBER} >= ${MIN_COVERAGE}" | bc -l) )); then
  print_success "Coverage meets minimum requirements (${LINE_COVERAGE} >= ${MIN_COVERAGE}%)"
else
  print_error "Coverage below minimum requirements (${LINE_COVERAGE} < ${MIN_COVERAGE}%)"
fi

# Detailed coverage report
print_header "DETAILED COVERAGE REPORT"
eval "lcov --rc lcov_branch=1 --list coverage/new_lcov.info"

# Open report in browser
print_info "Opening coverage report in browser..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  open coverage/html/index.html
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v xdg-open &> /dev/null; then
    xdg-open coverage/html/index.html
  fi
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
  start coverage/html/index.html
fi

print_header "COVERAGE ANALYSIS COMPLETE"
echo -e "Report location: ${YELLOW}$(pwd)/coverage/html/index.html${NC}"