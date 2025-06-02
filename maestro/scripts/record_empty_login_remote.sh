#!/bin/bash

# Remote recording script for empty login validation test
# This runs the test on Maestro Cloud for remote recording

echo "Starting remote recording of empty login validation test on Maestro Cloud..."

# Check if MAESTRO_CLOUD_API_KEY is set
if [ -z "$MAESTRO_CLOUD_API_KEY" ]; then
    echo "Error: MAESTRO_CLOUD_API_KEY environment variable is not set"
    echo "Please set your Maestro Cloud API key:"
    echo "export MAESTRO_CLOUD_API_KEY=your_api_key_here"
    exit 1
fi

# Upload and run the test on Maestro Cloud
maestro cloud \
  --app-file=build/app/outputs/flutter-apk/app-development-debug.apk \
  --format=junit \
  --output=maestro_test_results_empty_login_remote.xml \
  maestro/flows/login/empty_login_validation.yaml

echo "Remote recording completed on Maestro Cloud"
echo "Test results saved to maestro_test_results_empty_login_remote.xml"
echo "Video and detailed results available in Maestro Cloud dashboard"