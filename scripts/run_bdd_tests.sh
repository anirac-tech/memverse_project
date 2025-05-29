#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running BDD Integration Tests${NC}"

# Check if credentials are set
if [ -z "$MEMVERSE_USERNAME" ] || [ -z "$MEMVERSE_PASSWORD" ] || [ -z "$MEMVERSE_CLIENT_ID" ]; then
    echo -e "${RED}Error: Missing test credentials${NC}"
    echo "Please set environment variables:"
    echo "  export MEMVERSE_USERNAME='your_username'"
    echo "  export MEMVERSE_PASSWORD='your_password'"
    echo "  export MEMVERSE_CLIENT_ID='your_client_id'"
    echo ""
    echo "Or see test_setup.md for detailed instructions"
    exit 1
fi

echo -e "${GREEN}Credentials found, running tests...${NC}"

# Run integration tests with live credentials
flutter test integration_test/ \
    --dart-define=USERNAME=$MEMVERSE_USERNAME \
    --dart-define=PASSWORD=$MEMVERSE_PASSWORD \
    --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
    --flavor development

echo -e "${GREEN}BDD Integration tests completed${NC}"