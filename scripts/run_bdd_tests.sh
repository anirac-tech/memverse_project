#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() { echo -e "${YELLOW}➤ $1${NC}"; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }

# Function to detect and select an appropriate device
select_device() {
  print_info "Detecting available devices..."
  
  # Get list of devices and filter out headers and offline devices
  DEVICES_OUTPUT=$(flutter devices 2>/dev/null | grep -E "^[a-zA-Z0-9]" | grep -v "No devices detected" | grep -v "^If you" | head -10)
  
  if [ -z "$DEVICES_OUTPUT" ]; then
    print_warning "No devices detected. Tests will run without device specification."
    return 1
  fi
  
  print_info "Available devices:"
  echo "$DEVICES_OUTPUT" | while IFS= read -r line; do
    print_info "  $line"
  done
  
  # Try to find a Chrome/web device first (good for CI environments)
  CHROME_DEVICE=$(echo "$DEVICES_OUTPUT" | grep -i "chrome" | head -1 | awk '{print $1}')
  if [ ! -z "$CHROME_DEVICE" ]; then
    SELECTED_DEVICE="$CHROME_DEVICE"
    print_success "Selected Chrome device: $SELECTED_DEVICE"
    return 0
  fi
  
  # Try to find an emulator device
  EMULATOR_DEVICE=$(echo "$DEVICES_OUTPUT" | grep -i "emulator\|simulator" | head -1 | awk '{print $1}')
  if [ ! -z "$EMULATOR_DEVICE" ]; then
    SELECTED_DEVICE="$EMULATOR_DEVICE"
    print_success "Selected emulator device: $SELECTED_DEVICE"
    return 0
  fi
  
  # Fall back to first available device
  FIRST_DEVICE=$(echo "$DEVICES_OUTPUT" | head -1 | awk '{print $1}')
  if [ ! -z "$FIRST_DEVICE" ]; then
    SELECTED_DEVICE="$FIRST_DEVICE"
    print_success "Selected first available device: $SELECTED_DEVICE"
    return 0
  fi
  
  print_warning "No suitable device found"
  return 1
}

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

# Detect and select device
SELECTED_DEVICE=""
if select_device; then
  DEVICE_ARG="-d $SELECTED_DEVICE"
  print_info "Will run tests on device: $SELECTED_DEVICE"
else
  DEVICE_ARG=""
  print_info "Will run tests without specific device selection"
fi

# Run integration tests with live credentials and device selection
if [ ! -z "$DEVICE_ARG" ]; then
  flutter test integration_test/ \
      $DEVICE_ARG \
      --dart-define=USERNAME=$MEMVERSE_USERNAME \
      --dart-define=PASSWORD=$MEMVERSE_PASSWORD \
      --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
      --flavor development
else
  flutter test integration_test/ \
      --dart-define=USERNAME=$MEMVERSE_USERNAME \
      --dart-define=PASSWORD=$MEMVERSE_PASSWORD \
      --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
      --flavor development
fi

echo -e "${GREEN}BDD Integration tests completed${NC}"
