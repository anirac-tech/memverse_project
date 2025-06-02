# Maestro E2E Testing Demo - June 1, 2025

## What is Maestro? 🎭

Maestro is a simple, effective mobile UI testing framework that allows you to write tests for iOS
and Android apps using YAML files. Think of it as a way to automate tapping, typing, and verifying
what you see on your phone screen - just like a human would do, but much faster and more reliably.

### Why Use Maestro?

- **No Programming Required**: Tests are written in simple YAML format
- **Cross-Platform**: Works on both iOS and Android
- **Real Device Testing**: Tests run on actual devices or emulators
- **Visual Feedback**: Takes screenshots and can record videos
- **Fast Setup**: No complex configuration needed

## Prerequisites 📋

Before we start, make sure you have:

- Android device connected via USB (recommended) OR Android emulator running
- ADB (Android Debug Bridge) installed and working
- Maestro CLI installed (`curl -Ls "https://get.maestro.mobile.dev" | bash`)
- This Flutter app project

## Demo Overview 🎯

We'll demonstrate an **Empty Login Validation Test** that:

1. Opens the Memverse app
2. Tries to login without entering username/password
3. Verifies error messages appear
4. Records the entire process as a video

**Why This Test Matters**: This simulates a real user mistake - forgetting to fill in login fields.
Our app should gracefully handle this with clear error messages.

## Step 1: Preparation 🔧

### Run the Preparation Script

```bash
# Make the script executable and run it
chmod +x maestro_prep.sh
./maestro_prep.sh
```

This script will:

- ✅ Check if Android device/emulator is connected
- ✅ Verify Maestro can connect to the device
- ✅ Build and install the latest version of the app
- ✅ Confirm everything is ready for testing

### Manual Preparation (if script fails)

```bash
# Check device connection
adb devices

# Build the app
flutter build apk --debug --target lib/main_development.dart --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID

# Install the app
adb install build/app/outputs/flutter-apk/app-development-debug.apk

# Launch the app manually
adb shell am start -n com.spiritflightapps.memverse/.MainActivity
```

## Step 2: Run the Test 🚀

### Basic Test Run (No Recording)

```bash
maestro test maestro/flows/login/empty_login_validation.yaml
```

**What You'll See**:

- Maestro connects to your device
- App launches automatically
- Login button gets tapped (without entering credentials)
- Error messages appear: "Please enter your username" and "Please enter your password"
- Test passes with green checkmarks ✅

## Step 3: Record Local Video 📹

### Local Recording (Device Screen Only)

```bash
maestro test maestro/flows/login/empty_login_validation.yaml --format junit --output maestro_test_results_local.xml
```

**Local Recording Features**:

- Records your actual device screen
- Shows real app performance
- Includes actual animations and transitions
- File saved to your local machine
- Higher quality, but device-specific

### View Local Results

```bash
# Screenshots are automatically saved to:
ls ~/.maestro/tests/$(date +%Y-%m-%d)*

# Open the latest test folder to see screenshots
open ~/.maestro/tests/$(ls -t ~/.maestro/tests | head -1)
```

## Step 4: Record Remote Video 🌐

### Remote Recording (Maestro Cloud)

```bash
# Upload and run on Maestro Cloud
maestro cloud --apiKey YOUR_API_KEY maestro/flows/login/empty_login_validation.yaml
```

**Remote Recording Features**:

- Runs on standardized cloud devices
- Consistent environment across runs
- Easy sharing via web links
- Multiple device types available
- Slower but more reproducible

## Step 5: Compare Local vs Remote 🔍

### Key Differences to Look For:

| Aspect          | Local Recording      | Remote Recording         |
|-----------------|----------------------|--------------------------|
| **Speed**       | Faster (your device) | Slower (network latency) |
| **Quality**     | Device-dependent     | Standardized             |
| **Environment** | Your device setup    | Clean cloud environment  |
| **Sharing**     | Local files only     | Web links for sharing    |
| **Debugging**   | Immediate access     | Cloud dashboard          |
| **Cost**        | Free                 | May require paid plan    |

### Analysis Questions:

1. **Performance**: Does the app respond faster locally or remotely?
2. **Visual Differences**: Do error messages appear the same way?
3. **Timing**: Are there timing differences in animations?
4. **Reliability**: Which environment gives more consistent results?

## Understanding the Test File 📖

Let's break down what `maestro/flows/login/empty_login_validation.yaml` does:

```yaml
# Test metadata
appId: com.spiritflightapps.memverse
name: Empty Login Validation Test Flow
tags: [login, validation, empty-fields, user-error]

---
# Test steps (executed in order)
- takeScreenshot: "login_screen_empty"          # 📸 Capture initial state
- tapOn: "Login"                                # 👆 Tap login button
- waitForAnimationToEnd                         # ⏳ Wait for UI to settle
- takeScreenshot: "empty_login_validation_error" # 📸 Capture error state
- assertVisible:                                # ✅ Verify error messages
    text: "Please enter your username"
- assertVisible:
    text: "Please enter your password" 
- takeScreenshot: "validation_messages_visible" # 📸 Final confirmation
```

## Troubleshooting 🔧

### Common Issues and Solutions:

**"Unable to launch app"**

```bash
# Solution: Make sure app is installed
adb install build/app/outputs/flutter-apk/app-development-debug.apk
```

**"Device not found"**

```bash
# Solution: Check device connection
adb devices
# Should show your device listed
```

**"Element 'Login' not found"**

```bash
# Solution: Make sure app is on login screen
adb shell am start -n com.spiritflightapps.memverse/.MainActivity
```

**"Assertion failed"**

```bash
# Solution: Check if error messages match exactly
# Our app shows: "Please enter your username" and "Please enter your password"
```

## Next Steps 🚀

After completing this demo, you can:

1. **Create Your Own Tests**: Modify the YAML file to test different scenarios
2. **Test Happy Path**: Try `maestro/flows/happy_path.yaml` for successful login
3. **Explore More Flows**: Check `maestro/flows/` directory for other test examples
4. **Set Up CI/CD**: Integrate Maestro tests into your development pipeline
5. **Advanced Features**: Explore Maestro's device farms and advanced assertions

## Resources 📚

- **Maestro Documentation**: https://maestro.mobile.dev/
- **YAML Syntax Guide**: https://maestro.mobile.dev/reference/yaml-syntax
- **Our Test Files**: `maestro/flows/login/` directory
- **Troubleshooting Guide**: `maestro_rules.txt` in this project

## Success Criteria ✅

By the end of this demo, you should have:

- ✅ Successfully run a Maestro test
- ✅ Seen error validation in action
- ✅ Captured screenshots of the test process
- ✅ Understood the difference between local and remote testing
- ✅ Gained confidence to write your own mobile UI tests

**Remember**: Maestro makes mobile testing accessible to everyone - no complex programming required,
just clear YAML instructions that read like human actions! 🎉