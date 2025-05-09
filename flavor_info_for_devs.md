# Memverse App Flavors - Information for Developers

## Technical Overview of Flavors

In Flutter, flavors are implemented as build configurations that allow different environments of the
app to be built from the same codebase. This document explains how flavors are implemented in the
Memverse project and how to use them effectively.

## Flavor Configuration in Memverse

### Directory Structure

Each flavor has its own main entry point in the project:

```
lib/
├── main_development.dart
├── main_staging.dart
└── main_production.dart
```

### Flavor-specific Configuration

Each flavor can have its own configuration values:

- **API Endpoints**: Different flavors typically connect to different backend environments
- **Feature Flags**: Enable/disable features based on the flavor
- **Analytics**: Different analytics settings per flavor
- **Logging Levels**: More verbose logging in development, minimal in production

### App Metadata

Different flavors have different metadata settings in their respective build configurations:

- **App ID**: Usually suffixed with .dev, .staging, etc.
- **App Name**: May include a prefix/suffix to identify the flavor
- **App Icon**: Different icons help visually distinguish between flavors

## Debug Mode vs. Release Mode

### kDebugMode in Flutter

Flutter provides a constant called `kDebugMode` from the `flutter/foundation.dart` package:

```dart
import 'package:flutter/foundation.dart';

if (
kDebugMode) {
// This code only runs in debug mode
}
```

`kDebugMode` is `true` when:

- The app is run with `flutter run` without the `--release` or `--profile` flags
- You're developing with hot reload/restart
- The app is compiled in debug mode

It's `false` when:

- The app is built with `flutter build` or `flutter run --release`
- The app is deployed to app stores

### How AppLogger Uses kDebugMode

The AppLogger utility in Memverse uses `kDebugMode` to control logging behavior:

```dart
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(colors: false),
    level: kDebugMode ? Level.trace : Level.off, // Only log in debug mode
    filter: ProductionFilter(),
  );

  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) { // Only log in debug mode
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

// other methods...
}
```

This ensures that logs:

- Are visible during development
- Don't affect performance or expose sensitive information in production builds
- Are completely removed from release builds by the Dart compiler's tree-shaking

## Building and Testing Different Flavors

### Running Locally

```bash
# Development flavor
flutter run --flavor development --target lib/main_development.dart

# Staging flavor
flutter run --flavor staging --target lib/main_staging.dart

# Production flavor
flutter run --flavor production --target lib/main_production.dart
```

### Building for Distribution

```bash
# Development APK
flutter build apk --flavor development --target lib/main_development.dart

# Staging IPA
flutter build ipa --flavor staging --target lib/main_staging.dart

# Production Bundle
flutter build appbundle --flavor production --target lib/main_production.dart
```

## Continuous Integration and Deployment

Our CI pipeline builds and tests all flavors:

- Development builds are deployed to internal testers
- Staging builds go to TestFlight and Google Play internal testing
- Production builds are prepared for App Store and Play Store releases

## Best Practices

1. **Environment Isolation**: Keep development/staging/production environments completely isolated
2. **Consistent Configuration**: Ensure all flavors have the same features but point to different
   resources
3. **Feature Flags**: Use feature flags for features under development, not flavor-specific code
4. **Visual Distinction**: Make it obvious which flavor is running (app name, icon, color scheme)
5. **Testing**: Test all flavors before pushing, not just the one you're actively developing
6. **Logging**: Use AppLogger.d() and AppLogger.e() with appropriate error handling
7. **Secrets**: Never hardcode API keys or secrets - use environment variables with --dart-define