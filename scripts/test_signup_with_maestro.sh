#!/bin/bash

# Test Signup Feature with Maestro
# This script uses the flutter run command from setup.md to launch the app,
# then runs a Maestro test to verify the signup functionality.

set -e

echo "🚀 Starting Memverse app for Maestro testing..."

# Use the exact command from setup.md
echo "📱 Launching app with environment variables..."
flutter run --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID --dart-define=CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY --flavor development --target lib/main_development.dart &

# Store the Flutter process ID so we can kill it later
FLUTTER_PID=$!

echo "🔄 Waiting for app to start up..."
sleep 10

echo "🎭 Running Maestro signup test..."
maestro test maestro/flows/signup/test_signup_flow.yaml

echo "✅ Test completed!"

# Clean up - kill the Flutter process
echo "🧹 Cleaning up..."
kill $FLUTTER_PID 2>/dev/null || true

echo "🎉 Done!"