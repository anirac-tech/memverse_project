#!/bin/bash
set -e
source "$(dirname "$0")/project_config.sh"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

print_info() { echo -e "${YELLOW}➤ $1${NC}"; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }

print_info "Running widget tests with coverage (excluding golden and integration tests)..."
# Ensure previous coverage data is cleared or ignored if necessary
# Run tests, saving coverage to the default lcov.info
flutter test test/ --exclude-tags golden,integration --coverage

print_info "Processing widget test coverage data..."

# Check if coverage file exists
if [ ! -f "coverage/lcov.info" ]; then
    print_error "Widget coverage file (coverage/lcov.info) not found."
    exit 1
fi

# Convert space-separated glob patterns to lcov exclusion args
LCOV_EXCLUDE_ARGS=""
for pattern in $COVERAGE_EXCLUDES; do
  LCOV_EXCLUDE_ARGS+=" '$pattern'"
done

# Apply the exclusions, outputting to widget_lcov.info
eval "lcov --ignore-errors unused --remove coverage/lcov.info $LCOV_EXCLUDE_ARGS -o coverage/widget_lcov.info"
genhtml coverage/widget_lcov.info -o coverage/widget_html

# Calculate widget coverage percentage
WIDGET_COVERAGE_LINE=$(lcov --summary coverage/widget_lcov.info | grep "lines" | sed 's/.*lines.......: \([0-9.]*%\).*/\1/')
print_info "Widget Test Coverage: ${WIDGET_COVERAGE_LINE}"

# Check if widget coverage meets minimum requirement
WIDGET_COVERAGE_NUMBER=$(echo ${WIDGET_COVERAGE_LINE} | sed 's/%//')
# Ensure MIN_COVERAGE_WIDGET is treated as a number
MIN_COVERAGE_WIDGET_NUM=$(echo ${MIN_COVERAGE_WIDGET})

if (( $(echo "${WIDGET_COVERAGE_NUMBER} >= ${MIN_COVERAGE_WIDGET_NUM}" | bc -l) )); then
  print_success "Widget test coverage is acceptable: ${WIDGET_COVERAGE_LINE} (minimum: ${MIN_COVERAGE_WIDGET}%)"
else
  print_error "Widget test coverage is below acceptable levels: ${WIDGET_COVERAGE_LINE} (minimum: ${MIN_COVERAGE_WIDGET}%)"
  if [[ "$OSTYPE" == "darwin"* ]]; then open coverage/widget_html/index.html; fi
  echo "See widget test coverage report at: $(pwd)/coverage/widget_html/index.html"
  exit 1
fi
