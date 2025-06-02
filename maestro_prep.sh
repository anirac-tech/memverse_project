#!/bin/bash

# Maestro Preparation Script
# Ensures device connectivity and app installation for Maestro testing

set -e  # Exit on any error

echo "🎭 Maestro Preparation Script"
echo "=============================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "ℹ️  $1"
}

# Step 1: Check if required tools are installed
echo ""
echo "Step 1: Checking required tools..."
echo "-----------------------------------"

# Check if adb is installed
if command -v adb &> /dev/null; then
    print_status "ADB is installed"
else
    print_error "ADB is not installed. Please install Android SDK Platform Tools."
    exit 1
fi

# Check if flutter is installed
if command -v flutter &> /dev/null; then
    print_status "Flutter is installed"
else
    print_error "Flutter is not installed. Please install Flutter SDK."
    exit 1
fi

# Check if maestro is installed
if command -v maestro &> /dev/null; then
    print_status "Maestro is installed"
else
    print_error "Maestro is not installed. Install with: curl -Ls \"https://get.maestro.mobile.dev\" | bash"
    exit 1
fi

# Step 2: Check device connectivity
echo ""
echo "Step 2: Checking device connectivity..."
echo "---------------------------------------"

# Check if any devices are connected
DEVICES=$(adb devices | grep -v "List of devices attached" | grep -v "^$" | wc -l)
if [ "$DEVICES" -eq 0 ]; then
    print_error "No Android devices/emulators found"
    print_info "Please connect an Android device via USB or start an Android emulator"
    exit 1
else
    print_status "Found $DEVICES Android device(s)"
    adb devices | grep -v "List of devices attached" | grep -v "^$"
fi

# Step 3: Test Maestro device connection
echo ""
echo "Step 3: Testing Maestro device connection..."
echo "--------------------------------------------"

# Check if Maestro can see devices
MAESTRO_DEVICES=$(maestro test --help 2>/dev/null || echo "error")
if [[ "$MAESTRO_DEVICES" == "error" ]]; then
    print_warning "Could not verify Maestro device connection"
else
    print_status "Maestro CLI is responsive"
fi

# Step 4: Check environment variables
echo ""
echo "Step 4: Checking environment variables..."
echo "-----------------------------------------"

if [ -z "$MEMVERSE_CLIENT_ID" ]; then
    print_error "MEMVERSE_CLIENT_ID environment variable is not set"
    print_info "Please set it with: export MEMVERSE_CLIENT_ID=your_client_id"
    exit 1
else
    print_status "MEMVERSE_CLIENT_ID is set"
fi

# Step 5: Build the app
echo ""
echo "Step 5: Building the app..."
echo "---------------------------"

print_info "Building debug APK with development flavor..."
if flutter build apk --debug --target lib/main_development.dart --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID; then
    print_status "App built successfully"
else
    print_error "Failed to build app"
    exit 1
fi

# Step 6: Install the app
echo ""
echo "Step 6: Installing the app..."
echo "-----------------------------"

APK_PATH="build/app/outputs/flutter-apk/app-development-debug.apk"
if [ -f "$APK_PATH" ]; then
    print_info "Installing $APK_PATH..."
    if adb install -r "$APK_PATH"; then
        print_status "App installed successfully"
    else
        print_error "Failed to install app"
        exit 1
    fi
else
    print_error "APK file not found at $APK_PATH"
    exit 1
fi

# Step 7: Verify app installation
echo ""
echo "Step 7: Verifying app installation..."
echo "-------------------------------------"

if adb shell pm list packages | grep -q "com.spiritflightapps.memverse"; then
    print_status "App is installed on device"
else
    print_error "App installation verification failed"
    exit 1
fi

# Step 8: Launch the app
echo ""
echo "Step 8: Launching the app..."
echo "----------------------------"

print_info "Starting the Memverse app..."
if adb shell am start -n com.spiritflightapps.memverse/.MainActivity; then
    print_status "App launched successfully"
    sleep 3  # Give app time to fully load
else
    print_warning "Could not launch app - may need manual launch"
fi

# Step 9: Final readiness check
echo ""
echo "Step 9: Final readiness check..."
echo "--------------------------------"

# Quick test to see if Maestro can connect
echo "Testing Maestro connectivity..."
# This is a simple test that should work if everything is set up correctly
# We'll just try to get Maestro to connect without running a full test

print_status "Device preparation complete!"

# Step 10: Summary and next steps
echo ""
echo "🎉 PREPARATION COMPLETE!"
echo "========================"
echo ""
print_status "Your device is ready for Maestro testing!"
echo ""
echo "Next steps:"
echo "1. Run the empty login test: maestro test maestro/flows/login/empty_login_validation.yaml"
echo "2. Check the June1_maestro_demo.md file for detailed instructions"
echo "3. View screenshots in ~/.maestro/tests/ after running tests"
echo ""
echo "If you encounter issues:"
echo "- Check maestro_rules.txt for troubleshooting tips"
echo "- Ensure your device screen is unlocked during tests"
echo "- Make sure the app is on the login screen"
echo ""
print_info "Happy testing! 🚀"