# Maestro UI Tests Guide for Memverse

## Overview

Maestro is a powerful UI testing framework that allows us to create and run end-to-end tests for the
Memverse app. This guide explains how to use Maestro tests in our project.

## Prerequisites

### Installing Maestro

```bash
# Install Maestro CLI
curl -Ls "https://get.maestro.mobile.dev" | bash

# Verify installation
maestro -v
```

### Setting up Android Studio / Xcode

- Ensure you have Android Studio installed for Android testing
- Ensure you have Xcode installed for iOS testing
- Have at least one emulator/simulator set up

## Directory Structure

```
maestro/
├── flows/           # Test flow definitions
│   ├── login.yaml
│   ├── navigation.yaml
│   └── verses.yaml
└── scripts/         # Helper scripts
    └── run_maestro_test.sh
```

## Running Tests

### Using the Test Runner Script

```bash
# Run a specific test
./maestro/scripts/run_maestro_test.sh --play login

# Run a test and record video
./maestro/scripts/run_maestro_test.sh --video login

# Run all tests
./maestro/scripts/run_maestro_test.sh --play all
```

### Running with Environment Variables

```bash
USERNAME=$MEMVERSE_USERNAME \
PASSWORD=$MEMVERSE_PASSWORD \
CLIENT_ID=$MEMVERSE_CLIENT_ID \
./maestro/scripts/run_maestro_test.sh --play login
```

## Writing Test Flows

### Basic Structure

```yaml
appId: com.example.memverse.development
name: Test Flow Name
tags:
  - category1
  - category2

env:
  USERNAME: ${USERNAME}
  PASSWORD: ${PASSWORD}

onFlowStart:
  - launchApp:
      clearState: true
      clearKeychain: true

flows:
  main_flow:
    - assertVisible: "Text to find"
    - tapOn:
        id: "button_id"
    - takeScreenshot: "screenshot_name"
```

### Key Components

1. **Assertions**
   ```yaml
   - assertVisible: "Text or ID"
   - assertNotVisible: "Text or ID"
   - assertEnabled: "Button ID"
   ```

2. **Actions**
   ```yaml
   - tapOn:
       id: "button_id"
   - inputText:
       id: "input_field"
       text: "Hello World"
   - swipe:
       direction: LEFT
       duration: 300
   ```

3. **Screenshots**
   ```yaml
   - takeScreenshot: "meaningful_name"
   ```

4. **Flow Control**
   ```yaml
   - runFlow:
       file: another_flow.yaml
       flow: specific_flow_name
   - repeat:
       times: 3
       commands:
         - tapOn: "Button"
   ```

## Best Practices

### Naming Conventions

- Use descriptive flow names
- Use meaningful screenshot names
- Follow a consistent naming pattern for IDs

### Test Organization

1. Group related tests in the same flow file
2. Use tags for test categorization
3. Break down complex flows into smaller, reusable ones
4. Use environment variables for sensitive data

### Reliability

1. Add appropriate waits and assertions
2. Handle both success and failure cases
3. Clean up app state before tests
4. Use stable element identifiers

## Common Issues and Solutions

### App Not Starting

- Check if the app is properly installed
- Verify the correct `appId` is used
- Ensure emulator/simulator is running

### Elements Not Found

- Check if IDs/text are correct
- Add appropriate wait times
- Verify element visibility conditions

### Screenshot Issues

- Ensure sufficient storage space
- Check screenshot directory permissions
- Verify device screen is unlocked

## Working with Screenshots

### Location

- Android: `/data/user/0/<package-name>/cache/`
- iOS:
  `~/Library/Developer/CoreSimulator/Devices/<device-id>/data/Containers/Data/Application/<app-id>/tmp/`

### Best Practices

1. Use descriptive names
2. Take screenshots at key points
3. Clean up old screenshots
4. Include screenshots in test reports

## CI/CD Integration

### GitHub Actions Example

```yaml
jobs:
  maestro-tests:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - uses: mobile-dev-inc/action-maestro-cloud@v1
        with:
          api-key: ${{ secrets.MAESTRO_CLOUD_API_KEY }}
          app-file: build/ios/ipa/app.ipa
```

### Bitrise Example

```yaml
steps:
  - git-clone: {}
  - flutter-installer: {}
  - maestro-cloud-test:
      inputs:
        app_file: $BITRISE_APK_PATH
        api_key: $MAESTRO_CLOUD_API_KEY
```

## Resources

- [Maestro Documentation](https://maestro.mobile.dev/)
- [Maestro Cloud](https://cloud.mobile.dev/)
- [Maestro GitHub Actions](https://github.com/mobile-dev-inc/action-maestro-cloud)
- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)

## FAQ

### Q: When should I use Maestro vs. Flutter integration tests?

A: Use Maestro for end-to-end UI testing and when you need visual validation. Use Flutter
integration tests for testing deeper integration points and when you need more programmatic control.

### Q: How to handle dynamic content?

A: Use regular expressions in assertions, implement custom waiting strategies, or use more flexible
matching patterns.

### Q: Can I run tests on real devices?

A: Yes! Maestro supports both emulators/simulators and real devices. For real devices, ensure proper
USB debugging setup.

### Q: How to handle test flakiness?

A: Add appropriate waits, use stable identifiers, clean app state before tests, and implement retry
mechanisms for unstable operations.

### Q: How to debug test failures?

A: Use screenshots, check Maestro logs, review video recordings (if enabled), and use the
`--verbose` flag for detailed output.
