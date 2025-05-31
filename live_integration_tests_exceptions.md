# Live Integration Tests Exceptions

## Overview

This document identifies code branches, lines, and components that cannot reasonably be tested with
live integration tests due to technical limitations, environmental constraints, or practical
considerations.

## Categories of Untestable Code

### 1. Platform-Specific Native Code

**Location**: `android/`, `ios/`, `macos/`, `windows/`, `linux/` directories
**Reasoning**: Integration tests run in Flutter framework, not native platform code
**Examples**:

- Android Gradle build scripts (`android/app/build.gradle`)
- iOS Info.plist configurations (`ios/Runner/Info.plist`)
- Native plugin implementations
- Platform-specific permissions handling

### 2. Build and Configuration Files

**Location**: Root and platform directories
**Reasoning**: These files are processed at build time, not runtime
**Examples**:

```yaml
# pubspec.yaml - dependency declarations
# analysis_options.yaml - linting rules  
# dart_test.yaml - test configurations
# build.yaml - code generation settings
```

### 3. Development and Debug Code

**Location**: Throughout codebase with coverage ignore comments
**Reasoning**: Debug code should not run in production or test environments
**Examples**:

```dart
// coverage:ignore-start
if (kDebugMode) {
  debugPrint('Debug information');
}
// coverage:ignore-end

// Feedback button functionality (marked as ignored)
IconButton(
  // coverage:ignore-start
  onPressed: () {
    AppLogger.d('Feedback button pressed');
    // ... feedback handling
  },
  // coverage:ignore-end
)
```

### 4. Error Handling for Extreme Edge Cases

**Location**: `lib/src/features/auth/data/auth_service.dart`, error handling blocks
**Reasoning**: Requires specific network/system failures that are difficult to reproduce
**Examples**:

```dart
// Cannot reasonably test these in integration tests:
try {
  // Network call
} catch (DioException e) {
  // Specific network timeout scenarios
  // Certificate validation failures  
  // DNS resolution failures
} catch (SocketException e) {
  // Network interface unavailable
} catch (HandshakeException e) {
  // SSL/TLS handshake failures
}
```

### 5. Bootstrap and App Initialization Code

**Location**: `lib/src/bootstrap.dart`, `lib/main_*.dart` files
**Reasoning**: App initialization happens before tests can interact with the app
**Examples**:

```dart
void bootstrap(() => const App()) {
  // Error handling during app startup
  // Logger initialization
  // Service registration
  // These run before integration tests start
}
```

### 6. Complex Async Race Conditions

**Location**: `lib/src/features/verse/presentation/memverse_page.dart`
**Reasoning**: Timing-dependent code that requires specific race conditions
**Examples**:

```dart
// Difficult to test reliably in integration tests:
Future.delayed(const Duration(milliseconds: 1500), loadNextVerse);

// Widget disposal during async operations
useEffect(() {
  // Cleanup code when widget is disposed during async operation
  return cleanup;
}, [dependency]);
```

### 7. Device-Specific Hardware Features

**Location**: Throughout app where device capabilities are checked
**Reasoning**: Requires specific hardware that may not be available in test environment
**Examples**:

```dart
// Cannot test on all possible device configurations:
- Biometric authentication availability
- Camera hardware presence
- Network connectivity types (WiFi, cellular, etc.)
- Device orientation changes
- Battery level changes
- Memory pressure scenarios
```

### 8. Third-Party Service Integration Failures

**Location**: `lib/src/features/auth/data/auth_service.dart`
**Reasoning**: Requires third-party services to be in specific failure states
**Examples**:

```dart
// Cannot reliably test these scenarios:
- Memverse API server downtime
- OAuth provider failures
- Network proxy interference
- Firewall blocking requests
- Rate limiting responses
- Service maintenance modes
```

### 9. Locale and Internationalization Edge Cases

**Location**: `lib/l10n/` directory
**Reasoning**: Requires device to be in specific locale configurations
**Examples**:

```dart
// Difficult to test all combinations:
- Right-to-left languages
- Date/time formatting in all locales
- Currency formatting variations
- Number formatting edge cases
- Text rendering with special characters
```

### 10. File System and Storage Errors

**Location**: Throughout app where data persistence occurs
**Reasoning**: Requires specific file system failure conditions
**Examples**:

```dart
// Cannot easily simulate these conditions:
- Disk full scenarios
- File permission denied
- Storage corruption
- External storage unavailable
- Concurrent file access conflicts
```

## Recommended Testing Alternatives

### Unit Tests for Isolated Logic

```dart
// Test business logic separately from integration tests
test('verse reference validation logic', () {
  expect(VerseReferenceValidator.isValid('John 3:16'), true);
  expect(VerseReferenceValidator.isValid('invalid'), false);
});
```

### Widget Tests for UI Components

```dart
// Test widget behavior without full app context
testWidgets('login form validation', (tester) async {
  await tester.pumpWidget(LoginPage());
  // Test form validation logic
});
```

### Mock Tests for External Dependencies

```dart
// Test error handling with mocked failures
test('auth service network error handling', () async {
  when(mockDio.post(any)).thenThrow(DioException.connectionTimeout());
  // Test error handling logic
});
```

### Manual Testing Scenarios

These scenarios should be tested manually during QA:

- Device rotation during network calls
- App backgrounding/foregrounding during operations
- Network switching (WiFi to cellular)
- Low memory conditions
- Battery optimization interference
- System-level permission changes

## Integration Test Coverage Expectations

### Realistic Coverage Targets

- **Total App Coverage**: 75-85% (with integration tests)
- **Business Logic Coverage**: 90-95% (with unit tests)
- **UI Component Coverage**: 85-90% (with widget tests)
- **Error Handling Coverage**: 60-70% (due to edge case limitations)

### What Integration Tests Should Focus On

✅ **Happy Path User Flows**: Login → Verse Practice → Logout
✅ **Basic Error Handling**: Empty fields, invalid formats
✅ **UI State Changes**: Form validation, feedback colors
✅ **Data Flow**: User input → processing → UI updates
✅ **Navigation**: Screen transitions, back button behavior

### What Integration Tests Should NOT Attempt

❌ **Platform-specific native failures**
❌ **Network infrastructure problems**
❌ **Hardware availability edge cases**
❌ **Build-time configuration issues**
❌ **Race conditions requiring precise timing**
❌ **Third-party service outages**

## Code Coverage Exclusions

### Explicit Coverage Ignores

```dart
// These patterns indicate code that is intentionally excluded:
// coverage:ignore-start
// ... code block ...
// coverage:ignore-end

// Single line ignores:
debugPrint('Debug info'); // coverage:ignore-line
```

### File-Level Exclusions

Files that should be excluded from integration test coverage expectations:

- `lib/main_*.dart` - App entry points
- `lib/src/bootstrap.dart` - App initialization
- `**/debug.dart` - Debug-only utilities
- `**/*_test.dart` - Test files themselves
- Generated files (`*.g.dart`, `*.freezed.dart`)

## Conclusion

A realistic integration test suite for the Memverse app should achieve **75-85% coverage** by
focusing on:

1. Core user flows (authentication, verse practice)
2. Basic error handling (validation, empty states)
3. UI interactions (form submission, navigation)
4. State management (login state, verse progression)

The remaining 15-25% of uncovered code represents:

- Platform-specific implementations
- Extreme error conditions
- Debug and development utilities
- Build-time configurations
- Hardware-dependent features

This approach provides comprehensive testing coverage while acknowledging the practical limitations
of integration testing in real-world applications.