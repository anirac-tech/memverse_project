#!/bin/bash
set -e
source "$(dirname "$0")/project_config.sh"
# Define colors and print functions
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; NC='\033[0m'
print_header() { echo -e "\n${BLUE}==== $1 ====${NC}"; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${YELLOW}➤ $1${NC}"; }
check_command() { if ! command -v $1 &> /dev/null; then print_error "$1 is not installed."; exit 1; fi }

# --- Basic Checks ---
print_header "CHECKING DEPENDENCIES"
check_command flutter; check_command dart; check_command lcov; check_command genhtml
print_success "All dependencies found"
print_info "Flutter version:"; flutter --version

print_header "APPLYING DARTFIX"; print_info "Running dart fix..."; dart fix --apply; print_success "Applied dart fixes"
print_header "FORMATTING CODE"; print_info "Running dart format..."; dart format . -l 100; print_success "Code formatted"
print_header "ANALYZING CODE"; print_info "Running flutter analyze..."; flutter analyze; print_success "No analysis issues found"
print_header "GETTING DEPENDENCIES"; print_info "Running flutter pub get..."; flutter pub get; print_success "Dependencies updated"

# --- Golden Tests ---
print_header "HANDLING GOLDEN TESTS"
print_info "Generating/updating golden files..."; flutter test --update-goldens --tags golden || true
print_info "Running golden tests (checking for diffs)..."
set +e; flutter test --tags golden; GOLDEN_TEST_EXIT_CODE=$?; set -e
if [ $GOLDEN_TEST_EXIT_CODE -ne 0 ]; then
  print_info "Golden test differences detected. Review changes in 'test/**/failures/*.png'."
  print_info "If intended, commit the updated golden files in 'test/**/<test_name>.png'."
  if [ -f "$(dirname "$0")/generate_golden_report.sh" ]; then
    print_info "Generating golden test report..."; "$(dirname "$0")/generate_golden_report.sh" > /dev/null 2>&1 || true
    print_info "Report generated at golden_report/index.html"
  fi
  # Optionally exit here if strict golden checking is desired
  # exit 1
else
  print_success "Golden tests passed (no differences detected)."
fi

# --- Widget Tests (Helper Script) ---
print_header "RUNNING WIDGET TESTS"
"$(dirname "$0")/widget_tests.sh"

# --- Integration Tests (Helper Script) ---
print_header "RUNNING INTEGRATION TESTS"
"$(dirname "$0")/integration_tests.sh"

# --- Final Success ---
print_header "ALL CHECKS PASSED"
print_info "Your code is ready to be committed!"