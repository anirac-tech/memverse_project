#!/bin/bash
set -e

# Define colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up Memverse custom lint rules...${NC}"

# Navigate to the lint package directory
cd "$(dirname "$0")"

# Get the absolute path of the lint package
LINT_PATH=$(pwd)

# Navigate back to the root project
cd ..

# Check if pubspec.yaml exists
if [ ! -f "pubspec.yaml" ]; then
  echo -e "${RED}Error: pubspec.yaml not found in the project root.${NC}"
  exit 1
fi

# Add the custom_lint and memverse_lints to pubspec.yaml if not already present
if ! grep -q "custom_lint:" pubspec.yaml; then
  echo -e "${YELLOW}Adding custom_lint to pubspec.yaml...${NC}"
  # Use awk to add dependencies before the closing dev_dependencies section
  awk '/^dev_dependencies:/,/^[a-z]/ {
    if ($0 ~ /^[a-z]/ && $0 !~ /^dev_dependencies:/) {
      print "  custom_lint: ^0.5.6"
      print "  memverse_lints:"
      print "    path: ./memverse_lints"
      print ""
      print $0
      next
    }
    print $0
    next
  }
  !/^dev_dependencies:/,/^[a-z]/ { print $0 }' pubspec.yaml > pubspec.yaml.new
  mv pubspec.yaml.new pubspec.yaml
else
  echo -e "${GREEN}custom_lint already added to pubspec.yaml${NC}"
fi

# Check if analysis_options.yaml exists
if [ -f "analysis_options.yaml" ]; then
  # Check if the file already has custom_lint configuration
  if ! grep -q "custom_lint:" analysis_options.yaml; then
    echo -e "${YELLOW}Updating analysis_options.yaml with custom_lint configuration...${NC}"
    # Add custom_lint configuration to analysis_options.yaml
    cat >> analysis_options.yaml << EOL

# Custom lint configuration
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    - avoid_debug_print
    - avoid_log
EOL
  else
    echo -e "${GREEN}custom_lint already configured in analysis_options.yaml${NC}"
  fi
else
  echo -e "${YELLOW}Creating analysis_options.yaml with custom_lint configuration...${NC}"
  # Create a new analysis_options.yaml with custom_lint configuration
  cat > analysis_options.yaml << EOL
# Custom lint configuration
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    - avoid_debug_print
    - avoid_log
EOL
fi

# Install dependencies
echo -e "${YELLOW}Running flutter pub get...${NC}"
flutter pub get

echo -e "${GREEN}Memverse custom lint rules setup complete!${NC}"
echo -e "${YELLOW}Run 'dart run custom_lint' to check your code for prohibited logging methods.${NC}"
echo -e "${YELLOW}Or run 'dart run custom_lint --watch' for continuous checking.${NC}"