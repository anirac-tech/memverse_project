# Maestro Platform Guide - iOS, Android & Web

This guide provides platform-specific instructions and differences for running Maestro tests across
iOS, Android, and Web platforms.

## Quick Copy-Paste Commands

### Android 📱

```bash
# Check available Android devices
flutter devices | grep android

# Run happy path test on Android
export MEMVERSE_USERNAME="njwandroid@gmaiml.com"
export MEMVERSE_PASSWORD="fixmeplaceholder"
./maestro/scripts/run_maestro_test.sh --play happy_path --device emulator-5554

# With video recording
./maestro/scripts/run_maestro_test.sh --video happy_path --device emulator-5554

# Continuous mode for development
./maestro/scripts/run_maestro_test.sh --continuous happy_path --device emulator-5554
```

### iOS 🍎

```bash
# Check available iOS simulators
flutter devices | grep ios

# Run happy path test on iOS Simulator
export MEMVERSE_USERNAME="njwandroid@gmaiml.com"
export MEMVERSE_PASSWORD="fixmeplaceholder"
./maestro/scripts/run_maestro_test.sh --play happy_path --device "iPhone 14 Simulator (ios-simulator)"

# With video recording
./maestro/scripts/run_maestro_test.sh --video happy_path --device "iPhone 14 Simulator (ios-simulator)"

# Continuous mode for development
./maestro/scripts/run_maestro_test.sh --continuous happy_path --device "iPhone 14 Simulator (ios-simulator)"
```

### Web 🌐

```bash
# Check available web devices
flutter devices | grep chrome

# Run happy path test on Chrome
export MEMVERSE_USERNAME="njwandroid@gmaiml.com"
export MEMVERSE_PASSWORD="fixmeplaceholder"
./maestro/scripts/run_maestro_test.sh --play happy_path --device chrome

# With video recording
./maestro/scripts/run_maestro_test.sh --video happy_path --device chrome

# Continuous mode for development
./maestro/scripts/run_maestro_test.sh --continuous happy_path --device chrome
```

## Platform Differences & Capabilities

### Android 📱

**✅ What Works Well:**

- Native app testing with full gesture support
- Video recording with high quality
- Device/emulator detection is reliable
- Continuous mode works seamlessly
- File system access for screenshots
- Hardware button simulation

**⚠️ Considerations:**

- Requires Android SDK and emulator setup
- Device must be unlocked and developer options enabled
- Performance depends on emulator configuration
- Some gestures may be slower on older devices

**📱 Best Practices:**

- Use hardware-accelerated emulators (API 28+)
- Set animations to 0.5x or off in developer options
- Ensure sufficient RAM allocation (4GB+)
- Keep emulator unlocked during tests

### iOS 🍎

**✅ What Works Well:**

- iOS Simulator integration
- Gesture recognition and touch events
- App state management
- Screenshot capture

**⚠️ Considerations:**

- Limited to Simulator (no physical device support in some cases)
- Video recording may have different quality
- Simulator behavior differs from physical devices
- Some native iOS features not available in Simulator

**🍎 Best Practices:**

- Use latest iOS Simulator versions
- Test on multiple iOS versions if needed
- Be aware of Simulator limitations vs real devices
- Consider physical device testing for production validation

### Web 🌐

**✅ What Works Well:**

- Fast test execution
- No device setup required
- Great for CI/CD pipelines
- Cross-browser testing potential
- Easy debugging with browser developer tools

**⚠️ Limitations:**

- Web-only features and behaviors
- Different UI interaction patterns
- Limited mobile gesture simulation
- May not represent mobile user experience accurately

**🌐 Best Practices:**

- Use headless Chrome for CI environments
- Test responsive design breakpoints
- Validate mobile web experience separately
- Consider browser compatibility testing

## Setup Requirements by Platform

### Android Setup

```bash
# Install Android SDK
# Set up emulator
avdmanager create avd -n memverse_test -k "system-images;android-33;google_apis;x86_64"
emulator -avd memverse_test

# Verify Flutter can see device
flutter devices
```

### iOS Setup

```bash
# Install Xcode and Xcode Command Line Tools
xcode-select --install

# Open iOS Simulator
open -a Simulator

# Create iOS Simulator if needed
xcrun simctl create "iPhone 14 Test" "iPhone 14" "iOS 16.0"

# Verify Flutter can see simulator
flutter devices
```

### Web Setup

```bash
# Enable web support
flutter config --enable-web

# Verify Chrome is available
flutter devices
```

## Performance Comparison

| Platform    | Speed | Setup Effort | CI Friendly | Reliability |
|-------------|-------|--------------|-------------|-------------|
| **Web**     | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐        | ⭐⭐⭐⭐⭐       | ⭐⭐⭐⭐        |
| **Android** | ⭐⭐⭐   | ⭐⭐⭐          | ⭐⭐⭐         | ⭐⭐⭐⭐⭐       |
| **iOS**     | ⭐⭐⭐⭐  | ⭐⭐           | ⭐⭐          | ⭐⭐⭐⭐        |

## Recommended Testing Strategy

### Development Phase 🔧

1. **Primary**: Web testing for rapid iteration
2. **Secondary**: Android emulator for mobile-specific testing
3. **Validation**: iOS Simulator for cross-platform verification

### CI/CD Pipeline 🚀

1. **Always**: Web tests (fastest, most reliable)
2. **Regular**: Android emulator tests
3. **Scheduled**: iOS Simulator tests (if macOS runners available)

### Production Validation ✅

1. **Android**: Physical device testing
2. **iOS**: Physical device testing
3. **Web**: Multiple browser testing

## Troubleshooting by Platform

### Android Issues

```bash
# Device not found
adb devices
adb kill-server && adb start-server

# Emulator performance
emulator -avd memverse_test -gpu host -memory 4096

# App not installing
flutter clean && flutter pub get
flutter build apk --flavor development --target lib/main_development.dart
```

### iOS Issues

```bash
# Simulator not responding
xcrun simctl shutdown all
xcrun simctl boot "iPhone 14"

# Build issues
flutter clean && flutter pub get
flutter build ios --flavor development --target lib/main_development.dart
```

### Web Issues

```bash
# Chrome not launching
flutter config --enable-web
flutter doctor

# CORS issues (if testing with live API)
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

## Environment Variables Setup

**Required for all platforms:**

```bash
export MEMVERSE_USERNAME="njwandroid@gmaiml.com"
export MEMVERSE_PASSWORD="fixmeplaceholder"
export MEMVERSE_CLIENT_ID="your_client_id"
```

**Platform-specific considerations:**

- **Android**: Environment variables passed through ADB
- **iOS**: Environment variables work normally
- **Web**: Environment variables available in browser context

## Video Recording Capabilities

| Platform    | Quality | File Size | Supported |
|-------------|---------|-----------|-----------|
| **Android** | High    | Large     | ✅ Yes     |
| **iOS**     | Medium  | Medium    | ✅ Yes     |
| **Web**     | High    | Small     | ✅ Yes     |

## Best Platform for Different Use Cases

- **🚀 Rapid Development**: Web (fastest feedback loop)
- **📱 Mobile UX Testing**: Android Emulator (most representative)
- **🍎 iOS Validation**: iOS Simulator (iOS-specific behaviors)
- **🔄 CI/CD Pipeline**: Web → Android → iOS (in order of reliability)
- **📹 Demo Creation**: Android (best video quality)
- **🐛 Debugging**: Web (browser dev tools available)

## Summary

**Easiest to Setup**: Web > iOS > Android  
**Most Representative**: Android > iOS > Web  
**Best for CI**: Web > Android > iOS  
**Most Reliable**: Android > Web > iOS

Choose your platform based on your specific testing needs and infrastructure capabilities.