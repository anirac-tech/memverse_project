#!/bin/bash

# Script to run memverse.com website Maestro tests
# This script runs the full flow test and reports results

# Set up colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Navigate to project root
cd "$(dirname "$0")/../.." || exit 1

# Check if Maestro is installed
if ! command -v maestro &> /dev/null; then
    echo -e "${RED}Error: Maestro is not installed. Please install it first.${NC}"
    echo "Visit https://maestro.mobile.dev/getting-started/installing-maestro for installation instructions."
    exit 1
fi

echo -e "${YELLOW}=== Running Memverse.com Website Tests ===${NC}"
echo "Tests will run in Chrome on connected Android device"

# Run the complete test flow
echo -e "${YELLOW}Running create-login-delete flow test...${NC}"
maestro test maestro/flows/memverse_dot_com/create_login_delete_flow.yaml --format=plain

# Check the exit code
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed successfully!${NC}"
    exit 0
else
    echo -e "${RED}✗ Tests failed. Please check the output above for details.${NC}"
    exit 1
fi</code_edit>