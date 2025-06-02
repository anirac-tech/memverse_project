#!/bin/bash

# Test script for Maestro login flow with semantic identifiers
# Following Firebender Rules

echo "🔥 FIREBENDER TESTING SCRIPT"
echo "Testing Maestro login flow with semantic identifiers..."

# Check if device is connected
echo "📱 Checking device connection..."
adb devices

# Check if app is installed
echo "📦 Checking app installation..."
adb shell pm list packages | grep memverse

# Test the login flow
echo "🧪 Running Maestro test..."
maestro test maestro/flows/login.yaml

# Check test results
if [ $? -eq 0 ]; then
    echo "✅ Test PASSED!"
else
    echo "❌ Test FAILED!"
    echo "Check debug output in ~/.maestro/tests/"
fi

echo "🏁 Test completed!"