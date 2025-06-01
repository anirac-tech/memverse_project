#!/bin/bash

# Local recording script for empty login validation test
# This records the test locally on connected Android device

echo "Starting local test of empty login validation..."

# Clear any previous test data
adb shell am force-stop com.spiritflightapps.memverse
adb shell pm clear com.spiritflightapps.memverse

# Run the test with local recording
maestro test \
  --format=junit \
  --output=maestro_test_results_empty_login_local.xml \
  maestro/flows/login/empty_login_validation.yaml

echo "Local test completed. Screenshots saved to debug output."
echo "Test results saved to maestro_test_results_empty_login_local.xml"
echo "For video recording, use: maestro studio maestro/flows/login/empty_login_validation.yaml"
