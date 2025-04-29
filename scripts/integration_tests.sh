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

# Check for required environment variables
if [ -z "$MEMVERSE_USERNAME" ] || [ -z "$MEMVERSE_PASSWORD" ] || [ -z "$MEMVERSE_CLIENT_ID" ]; then
  print_error "Missing environment variables (MEMVERSE_USERNAME, MEMVERSE_PASSWORD, MEMVERSE_CLIENT_ID) required for integration tests."
  print_info "Skipping integration tests."
  # Exit gracefully instead of failing the whole script if env vars are missing
  exit 0
fi

print_info "Running integration tests with coverage (flavor: development)..."

# Define dart-define arguments
DART_DEFINE_ARGS="--dart-define=USERNAME=$MEMVERSE_USERNAME --dart-define=PASSWORD=$MEMVERSE_PASSWORD --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID"

# Run tests with flavor, dart-defines, and isolated coverage path
# Add --exclude-tags skipIntegration tag here if needed later
flutter test integration_test/ --tags integration --flavor development $DART_DEFINE_ARGS --coverage --coverage-path coverage/temp_integration_lcov.info

print_info "Processing integration test coverage data..."

# Check if the temporary coverage file exists
if [ ! -f "coverage/temp_integration_lcov.info" ]; then
  print_error "Temporary integration coverage file (coverage/temp_integration_lcov.info) not found."
  exit 1
fi

# Convert space-separated glob patterns to lcov exclusion args
LCOV_EXCLUDE_ARGS=""
for pattern in $COVERAGE_EXCLUDES; do
  LCOV_EXCLUDE_ARGS+=" '$pattern'"
done

# Apply the exclusions using the temporary file as input and outputting to the final integration file
eval "lcov --ignore-errors unused --remove coverage/temp_integration_lcov.info $LCOV_EXCLUDE_ARGS -o coverage/integration_lcov.info"
# Remove the temporary file
rm coverage/temp_integration_lcov.info

# Generate HTML report from the processed integration coverage file
genhtml coverage/integration_lcov.info -o coverage/integration_html

# Calculate integration coverage percentage from the processed file
INTEGRATION_COVERAGE_LINE=$(lcov --summary coverage/integration_lcov.info | grep "lines" | sed 's/.*lines.......: \([0-9.]*%\).*/\1/')
print_info "Integration Test Coverage: ${INTEGRATION_COVERAGE_LINE}"

# Check if integration coverage meets minimum requirement
INTEGRATION_COVERAGE_NUMBER=$(echo ${INTEGRATION_COVERAGE_LINE} | sed 's/%//')
# Ensure MIN_COVERAGE_INTEGRATION is treated as a number
MIN_COVERAGE_INTEGRATION_NUM=$(echo ${MIN_COVERAGE_INTEGRATION})

if (( $(echo "${INTEGRATION_COVERAGE_NUMBER} >= ${MIN_COVERAGE_INTEGRATION_NUM}" | bc -l) )); then
  print_success "Integration test coverage is acceptable: ${INTEGRATION_COVERAGE_LINE} (minimum: ${MIN_COVERAGE_INTEGRATION}%)"
else
  print_error "Integration test coverage is below acceptable levels: ${INTEGRATION_COVERAGE_LINE} (minimum: ${MIN_COVERAGE_INTEGRATION}%)"
  if [[ "$OSTYPE" == "darwin"* ]]; then open coverage/integration_html/index.html; fi
  echo "See integration test coverage report at: $(pwd)/coverage/integration_html/index.html"
  exit 1
fi
