# Memverse Lints

A custom lint package for the Memverse project that enforces the use of AppLogger instead of
debugPrint or log.

## Features

This package provides the following lint rules:

1. `avoid_debug_print`: Detects usage of `debugPrint()` and suggests replacing with `AppLogger.d()`
2. `avoid_log`: Detects usage of `log()` and suggests replacing with `AppLogger.d()`

## Quick Fixes

Both lint rules come with quick fixes that will:

1. Replace the prohibited logging method with the appropriate AppLogger method
2. Add the required import for AppLogger if it's not already present

## Setup

### 1. Add dependencies

Add the following to your root `pubspec.yaml`:

```yaml
dev_dependencies:
  custom_lint: ^0.5.6
  memverse_lints:
    path: ./memverse_lints
```

### 2. Configure analysis_options.yaml

Create or update your `analysis_options.yaml` file to include the custom lints:

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Enable all rules from memverse_lints
    - avoid_debug_print
    - avoid_log
```

### 3. Run the linter

Run the linter with:

```bash
# For a one-time analysis
dart run custom_lint

# For watching mode (recommended during development)
dart run custom_lint --watch
```

## How It Works

When you use `debugPrint()` or `log()` in your code, the linter will flag it as an error:

```dart
void example() {
  debugPrint(
      'Hello, world!'); // Error: Avoid using debugPrint. Use AppLogger.d() instead for consistent logging.
  log(
      'Another message'); // Error: Avoid using log(). Use AppLogger.d() instead for consistent logging.
}
```

The quick fix will automatically convert these to:

```dart
import 'package:memverse/src/utils/app_logger.dart';

void example() {
  AppLogger.d('Hello, world!');
  AppLogger.d('Another message');
}
```

## Benefits

1. **Consistency**: Ensures logging is handled consistently through AppLogger
2. **Debugging control**: AppLogger only logs in debug mode, reducing noise in production
3. **Automated migration**: Easy to fix existing code through quick fixes