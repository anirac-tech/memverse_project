# Logging Standards and Tools

This document outlines the logging standards and tools used in the Memverse project.

## AppLogger Overview

The Memverse project uses a custom logging utility called `AppLogger` that provides consistent
logging across all app flavors and ensures that logs are only output in debug mode. This utility
wraps the [logger](https://pub.dev/packages/logger) package.

### Basic Usage

```dart
import 'package:memverse/src/utils/app_logger.dart';

// Debug logging
AppLogger.d
('This is a debug message');

// Error logging with stacktrace
try {
// Some code that might throw
} catch (e, stackTrace) {
AppLogger.e('An error occurred', e, stackTrace);
}
```

### Available Methods

| Method          | Description             | Parameters                           |
|-----------------|-------------------------|--------------------------------------|
| `AppLogger.t()` | Trace (verbose) logging | `message`, `[error]`, `[stackTrace]` |
| `AppLogger.d()` | Debug logging           | `message`, `[error]`, `[stackTrace]` |
| `AppLogger.i()` | Info logging            | `message`, `[error]`, `[stackTrace]` |
| `AppLogger.w()` | Warning logging         | `message`, `[error]`, `[stackTrace]` |
| `AppLogger.e()` | Error logging           | `message`, `[error]`, `[stackTrace]` |
| `AppLogger.f()` | Fatal error logging     | `message`, `[error]`, `[stackTrace]` |

All methods conditionally log based on `kDebugMode`, ensuring logs only appear during development.

## Prohibited Logging Methods

The following logging methods are prohibited in this project:

- `debugPrint()` from Flutter's foundation package
- `log()` from dart:developer

Instead, use the appropriate `AppLogger` methods for all logging needs.

## Enforcement Tools

Multiple tools enforce the logging standards:

### 1. Pre-commit Hook

A pre-commit hook checks for prohibited logging methods and prevents commits if any are found:

```bash
$ git commit -m "Add new feature"
==== CHECKING FOR PROHIBITED LOGGING METHODS ====
➤ Ensuring all logging uses AppLogger instead of debugPrint or log...
✗ Found prohibited logging methods. Please use AppLogger.d() or AppLogger.e() instead:
lib/src/features/user/profile_screen.dart:52:    debugPrint('Profile loaded');
```

### 2. CI Pipeline Check

The GitHub Actions workflow includes a job that checks for prohibited logging methods:

```yaml
check-logging-standards:
  name: Check Logging Standards
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4

    - name: Check for prohibited logging methods
      run: |
        grep -r --include="*.dart" -E "(debugPrint\(| log\()" lib || true
        # If any matches are found, fail the build
```

### 3. Custom Lint Rules

The project includes custom lint rules in the `memverse_lints` package that:

- Flag `debugPrint()` and `log()` usage as errors
- Provide quick fixes to automatically convert them to `AppLogger` calls

#### Setting Up Lint Rules

```bash
./memverse_lints/setup_lints.sh
```

#### Running the Linter

```bash
dart run custom_lint
```

#### Quick Fix Example

Before:

```dart
void onUserLogin() {
  debugPrint('User logged in');
}
```

After using the quick fix:

```dart
import 'package:memverse/src/utils/app_logger.dart';

void onUserLogin() {
  AppLogger.d('User logged in');
}
```

## Benefits of Standardized Logging

1. **Consistency**: All log messages follow the same format
2. **Conditional logging**: Log messages only appear in debug builds
3. **Enhanced debugging**: Full error objects and stack traces are easily included
4. **Production safety**: No debug messages in release builds
5. **Centralized control**: Logging behavior can be modified in one place