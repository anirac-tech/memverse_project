# Maestro Recording Guide

This guide provides comprehensive instructions for recording and running Maestro tests for the
Memverse app, with a focus on emulator setup and recording capabilities.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Emulator Setup](#emulator-setup)
- [Recording Maestro Tests](#recording-maestro-tests)
- [Running Recorded Tests](#running-recorded-tests)
- [Video Recording](#video-recording)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Install Maestro

```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
```

### Verify Installation

```bash
maestro --version
```

### Install Android Emulator (if not already installed)

```bash
# Install Android Studio or just the command line tools
# Then create an AVD (Android Virtual Device)
```

## Emulator Setup

### Recommended Emulator Configuration

For optimal Maestro recording and testing, use these recommended settings:

#### Create AVD via Android Studio

1. Open Android Studio
2. Go to Tools → AVD Manager
3. Create Virtual Device
4. Choose device: **Pixel 6** (or similar modern device)
5. Choose system image: **API 33 (Android 13)** or **API 34 (Android 14)**
6. Advanced settings:
    - **RAM**: 4GB minimum
    - **VM Heap**: 512MB
    - **Enable Hardware GPU acceleration**
    - **Enable Snapshot saving**

#### Create AVD via Command Line

```bash
# List available system images
avdmanager list targets

# Create AVD
avdmanager create avd \
  -n memverse_test_emulator \
  -k "system-images;android-33;google_apis;x86_64" \
  -d "pixel_6"

# Start emulator
emulator -avd memverse_test_emulator
```

### Emulator Settings for Recording

Once the emulator is running, configure these settings for better recording:

1. **Developer Options** (Settings → About Phone → tap Build Number 7 times)
    - Enable "Stay Awake"
    - Set "Animation Scale" to 0.5x or off
    - Set "Transition Animation Scale" to 0.5x or off
    - Set "Animator Duration Scale" to 0.5x or off

2. **Display Settings**
    - Set brightness to maximum
    - Disable auto-rotate (use portrait mode)
    - Set screen timeout to maximum

## Recording Maestro Tests

### Basic Recording Command

```bash
# Navigate to project root
cd /path/to/memverse_project

# Start recording a new flow
./maestro/scripts/run_maestro_test.sh record login_flow
```

### Recording Process

1. **Prepare the app**: Make sure your app is installed and ready
   ```bash
   # Install the development version
   flutter build apk --flavor development
   flutter install --flavor development
   ```

2. **Start recording**: Run the recording command
   ```bash
   ./maestro/scripts/run_maestro_test.sh record happy_path_new
   ```

3. **Perform actions**:
    - Launch the app manually on the emulator
    - Perform the user journey you want to record
    - Login with credentials
    - Navigate through screens
    - Interact with UI elements

4. **Stop recording**: Press `Ctrl+C` when finished

5. **Review recording**: The recorded flow will be saved to `maestro/recordings/`

### Recording Best Practices

#### Environment Setup

```bash
# Set environment variables before recording
export MEMVERSE_USERNAME="njwandroid@gmaiml.com"
export MEMVERSE_PASSWORD="fixmeplaceholder"
export MEMVERSE_CLIENT_ID="your_client_id"
```

#### Recording Tips

- **Go slowly**: Allow time between actions for UI to respond
- **Wait for elements**: Ensure elements are visible before interacting
- **Use clear gestures**: Tap center of buttons/elements
- **Avoid quick swipes**: Use deliberate, slower gestures
- **Check orientation**: Keep device in portrait mode
- **Stable network**: Ensure good internet connection for API calls

## Running Recorded Tests

### Run Individual Flow

```bash
# Run a specific recorded flow
./maestro/scripts/run_maestro_test.sh run happy_path

# Run with video recording
./maestro/scripts/run_maestro_test.sh run happy_path --video

# Run with specific device
./maestro/scripts/run_maestro_test.sh run login --device emulator-5554
```

### Run All Flows

```bash
# List available flows
./maestro/scripts/run_maestro_test.sh list

# Run each flow individually
for flow in login happy_path navigation; do
  ./maestro/scripts/run_maestro_test.sh run $flow --video
done
```

## Video Recording

### Enable Video Recording

```bash
# Record video during test execution
./maestro/scripts/run_maestro_test.sh run happy_path --video
```

Videos are saved to `maestro/videos/` with timestamp:

- Format: `{flow_name}_{timestamp}.mp4`
- Example: `happy_path_20250530_221545.mp4`

### Video Settings

- **Resolution**: Matches emulator resolution
- **Format**: MP4
- **Quality**: High quality suitable for documentation

### Viewing Videos

```bash
# Open video directory
open maestro/videos/

# Play specific video (macOS)
open maestro/videos/happy_path_latest.mp4

# Play specific video (Linux)
xdg-open maestro/videos/happy_path_latest.mp4
```

## Available Flows

### Current Test Flows

1. **login.yaml** - User authentication flow
2. **happy_path.yaml** - Complete user journey with verse interactions
3. **navigation.yaml** - Screen navigation testing
4. **verses.yaml** - Verse management operations

### Flow Structure

Each flow includes:

- **Environment variables** for credentials
- **Screenshot capture** at key points
- **Assertions** for expected elements
- **Waits** for proper timing

## Troubleshooting

### Common Issues

#### Maestro Not Found

```bash
# Add Maestro to PATH
echo 'export PATH="$HOME/.maestro/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Emulator Connection Issues

```bash
# Check connected devices
adb devices

# Restart ADB if needed
adb kill-server
adb start-server

# Connect to specific emulator
adb connect emulator-5554
```

#### Recording Failures

1. **Check app installation**:
   ```bash
   adb shell pm list packages | grep memverse
   ```

2. **Verify app is running**:
   ```bash
   adb shell dumpsys activity activities | grep memverse
   ```

3. **Check emulator performance**:
    - Increase RAM allocation
    - Enable hardware acceleration
    - Close other applications

#### Element Not Found Errors

- **Add wait commands**: `- wait: 2000`
- **Use text content**: Instead of IDs when possible
- **Check element hierarchy**: Use UI inspector tools
- **Update selectors**: Ensure they match current UI

### Debug Mode

```bash
# Run with verbose output
./maestro/scripts/run_maestro_test.sh run happy_path --debug

# Check Maestro logs
maestro test maestro/flows/happy_path.yaml --verbose
```

## Integration with CI/CD

### GitHub Actions Setup

```yaml
- name: Run Maestro Tests
  run: |
    export MEMVERSE_USERNAME="${{ secrets.MEMVERSE_USERNAME }}"
    export MEMVERSE_PASSWORD="${{ secrets.MEMVERSE_PASSWORD }}"
    ./maestro/scripts/run_maestro_test.sh run happy_path --video

- name: Upload Test Videos
  uses: actions/upload-artifact@v3
  with:
    name: maestro-videos
    path: maestro/videos/
```

### Local Automation

```bash
# Run all tests with reports
./scripts/run_maestro_suite.sh

# Generate test report
./scripts/generate_maestro_report.sh
```

## Best Practices Summary

1. ✅ **Use emulator consistently** for reproducible results
2. ✅ **Set up environment variables** before recording
3. ✅ **Record slowly and deliberately** for reliable playback
4. ✅ **Include waits and assertions** for stability
5. ✅ **Capture videos** for documentation and debugging
6. ✅ **Test on multiple devices/orientations** when needed
7. ✅ **Keep flows focused** on specific user journeys
8. ✅ **Version control recordings** for team collaboration

## Additional Resources

- [Maestro Documentation](https://maestro.mobile.dev)
- [Android Emulator Guide](https://developer.android.com/studio/run/emulator)
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Project Test Setup Guide](test_setup.md)