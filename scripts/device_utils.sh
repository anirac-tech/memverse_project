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
  
  # Get list of devices, extract device IDs properly
  DEVICES_OUTPUT=$(flutter devices 2>/dev/null)
  
  if [ -z "$DEVICES_OUTPUT" ] || echo "$DEVICES_OUTPUT" | grep -q "No devices detected"; then
    print_warning "No devices detected. Tests will run without device specification."
    SELECTED_DEVICE=""
    DEVICE_ARG=""
    return 1
  fi
  
  print_info "Available devices found."
  
  # Skip Chrome/web devices for integration tests (not supported yet)
  # Try to find an iOS Simulator first
  IOS_DEVICE=$(echo "$DEVICES_OUTPUT" | grep -A1 "iPhone.*Simulator\|iPad.*Simulator" | grep "•" | awk -F'•' '{print $2}' | head -1 | xargs)
  if [ ! -z "$IOS_DEVICE" ]; then
    SELECTED_DEVICE="$IOS_DEVICE"
    DEVICE_ARG="-d $SELECTED_DEVICE"
    print_success "Selected iOS Simulator: $SELECTED_DEVICE"
    return 0
  fi
  
  # Try to find an Android emulator
  ANDROID_DEVICE=$(echo "$DEVICES_OUTPUT" | grep -A1 "emulator" | grep "•" | awk -F'•' '{print $2}' | head -1 | xargs)
  if [ ! -z "$ANDROID_DEVICE" ]; then
    SELECTED_DEVICE="$ANDROID_DEVICE"
    DEVICE_ARG="-d $SELECTED_DEVICE"
    print_success "Selected Android emulator: $SELECTED_DEVICE"
    return 0
  fi
  
  # Try to find a physical Android device
  ANDROID_PHYSICAL=$(echo "$DEVICES_OUTPUT" | grep -A1 "android-arm64\|android-x64" | grep "•" | awk -F'•' '{print $2}' | head -1 | xargs)
  if [ ! -z "$ANDROID_PHYSICAL" ]; then
    SELECTED_DEVICE="$ANDROID_PHYSICAL"
    DEVICE_ARG="-d $SELECTED_DEVICE"
    print_success "Selected Android device: $SELECTED_DEVICE"
    return 0
  fi
  
  # Try macOS as last resort (though integration tests may not work well on macOS)
  MACOS_DEVICE=$(echo "$DEVICES_OUTPUT" | grep -A1 "macOS (desktop)" | grep "•" | awk -F'•' '{print $2}' | head -1 | xargs)
  if [ ! -z "$MACOS_DEVICE" ]; then
    SELECTED_DEVICE="$MACOS_DEVICE"
    DEVICE_ARG="-d $SELECTED_DEVICE"
    print_warning "Selected macOS device: $SELECTED_DEVICE (integration tests may not work properly)"
    return 0
  fi
  
  print_warning "No suitable device found (skipping Chrome/web as not supported for integration tests)"
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
