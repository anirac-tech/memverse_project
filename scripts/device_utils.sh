#!/bin/bash

# Utility functions for device detection and selection
# Source this file to use these functions in other scripts

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
# Sets global variable SELECTED_DEVICE and DEVICE_ARG
# Returns 0 if device found, 1 if not
select_device() {
  print_info "Detecting available devices..."
  
  # Get list of devices and filter out headers and offline devices
  DEVICES_OUTPUT=$(flutter devices 2>/dev/null | grep -E "^[a-zA-Z0-9]" | grep -v "No devices detected" | grep -v "^If you" | head -10)
  
  if [ -z "$DEVICES_OUTPUT" ]; then
    print_warning "No devices detected. Tests will run without device specification."
    SELECTED_DEVICE=""
    DEVICE_ARG=""
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
    DEVICE_ARG="-d $SELECTED_DEVICE"
    print_success "Selected Chrome device: $SELECTED_DEVICE"
    return 0
  fi
  
  # Try to find an emulator device
  EMULATOR_DEVICE=$(echo "$DEVICES_OUTPUT" | grep -i "emulator\|simulator" | head -1 | awk '{print $1}')
  if [ ! -z "$EMULATOR_DEVICE" ]; then
    SELECTED_DEVICE="$EMULATOR_DEVICE"
    DEVICE_ARG="-d $SELECTED_DEVICE"
    print_success "Selected emulator device: $SELECTED_DEVICE"
    return 0
  fi
  
  # Fall back to first available device
  FIRST_DEVICE=$(echo "$DEVICES_OUTPUT" | head -1 | awk '{print $1}')
  if [ ! -z "$FIRST_DEVICE" ]; then
    SELECTED_DEVICE="$FIRST_DEVICE"
    DEVICE_ARG="-d $SELECTED_DEVICE"
    print_success "Selected first available device: $SELECTED_DEVICE"
    return 0
  fi
  
  print_warning "No suitable device found"
  SELECTED_DEVICE=""
  DEVICE_ARG=""
  return 1
}

# Function to run flutter test with automatic device selection
# Usage: run_flutter_test_with_device "test_directory" "additional_args"
run_flutter_test_with_device() {
  local test_dir="$1"
  local additional_args="$2"
  
  # Select device
  if select_device; then
    print_info "Running tests on device: $SELECTED_DEVICE"
    flutter test "$test_dir" $DEVICE_ARG $additional_args
  else
    print_info "Running tests without specific device selection"
    flutter test "$test_dir" $additional_args
  fi
}