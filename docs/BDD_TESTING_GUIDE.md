# BDD Testing Guide

This guide explains how to write and run BDD (Behavior-Driven Development) tests for the Memverse app using the `bdd_widget_test` package.

## Overview

BDD tests help us write tests that are readable and describe user behavior in plain language. We use Gherkin syntax (Given/When/Then) to structure our tests.

## Test Structure

### 1. Feature Files (.feature)

Feature files describe the behavior in human-readable format:

```gherkin
Feature: Theme Toggle
  As a user
  I want to toggle between light and dark themes
  So that I can use the app comfortably

  Scenario: User toggles to dark theme
    Given the app is running in light mode
    When I navigate to settings
    And I toggle the dark mode switch
    Then the app should display in dark theme
```

### 2. Test Implementation Files (*_test.dart)

Test files implement the steps defined in feature files:

```dart
import 'package:bdd_widget_test/bdd_widget_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme Toggle BDD Tests', () {
    testWidgets('user can toggle to dark theme', (tester) async {
      await givenTheAppIsRunningInLightMode(tester);
      await whenINavigateToSettings(tester);
      await andIToggleTheDarkModeSwitch(tester);
      await thenTheAppShouldDisplayInDarkTheme(tester);
    });
  });
}

Future<void> givenTheAppIsRunningInLightMode(WidgetTester tester) async {
  // Implementation
}
```

## Current BDD Tests

### Theme Toggle Tests
- **File**: `integration_test/theme_toggle_test.dart`
- **Feature**: `integration_test/theme_toggle.feature`
- **Coverage**: Light/dark theme toggling, persistence across navigation

### Quiz Features Tests
- **File**: `integration_test/quiz_features_test.dart`
- **Feature**: `integration_test/quiz_features.feature`
- **Coverage**: Reference quiz, verse text quiz, navigation between quizzes

### Authentication Tests
- **File**: `integration_test/authentication_bdd_test_test.dart`
- **Feature**: `integration_test/authentication_bdd_test.feature`
- **Coverage**: Login flow, credentials validation

## Running BDD Tests

### Run All Integration Tests
```bash
flutter test integration_test
```

### Run Specific BDD Test
```bash
flutter test integration_test/theme_toggle_test.dart
flutter test integration_test/quiz_features_test.dart
```

### Run With Development Flavor
```bash
flutter test integration_test/theme_toggle_test.dart \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=AUTOSIGNIN=true \
  --flavor development \
  --target lib/main_development.dart
```

## Writing New BDD Tests

### Step 1: Create a Feature File

Create a `.feature` file describing the behavior:

```gherkin
Feature: New Feature
  As a user
  I want to do something
  So that I can achieve a goal

  Scenario: Happy path
    Given initial state
    When action is performed
    Then expected result occurs
```

### Step 2: Create the Test Implementation

Create a `*_test.dart` file:

```dart
import 'package:bdd_widget_test/bdd_widget_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('New Feature BDD Tests', () {
    testWidgets('happy path test', (tester) async {
      await givenInitialState(tester);
      await whenActionIsPerformed(tester);
      await thenExpectedResultOccurs(tester);
    });
  });
}

// Implement step functions
Future<void> givenInitialState(WidgetTester tester) async {
  // Setup code
}

Future<void> whenActionIsPerformed(WidgetTester tester) async {
  // Action code
}

Future<void> thenExpectedResultOccurs(WidgetTester tester) async {
  // Verification code
}
```

## Best Practices

### 1. Use Descriptive Names
- Function names should match the Given/When/Then statements
- Use camelCase for function names
- Be specific about what is being tested

### 2. Keep Steps Atomic
Each step should do one thing:
```dart
// Good
Future<void> givenTheAppIsRunning(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();
}

// Bad - doing too much
Future<void> givenTheAppIsRunningAndUserIsLoggedIn(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();
  await login(tester);
  await navigateToHome(tester);
}
```

### 3. Add Appropriate Waits
```dart
// Wait for animations and async operations
await tester.pumpAndSettle();

// Wait for specific duration if needed
await tester.pumpAndSettle(const Duration(seconds: 2));
```

### 4. Use Keys for Important Widgets
In your widgets, add keys for testability:
```dart
SwitchListTile(
  key: const Key('themeModeSwitch'),
  title: const Text('Dark Mode'),
  value: isDarkMode,
  onChanged: (value) => toggleTheme(value),
)
```

### 5. Provide Helpful Assertions
```dart
expect(
  find.byType(SettingsScreen),
  findsOneWidget,
  reason: 'Settings screen should be displayed after navigation',
);
```

## Common Patterns

### Starting the App
```dart
Future<void> givenTheAppIsRunning(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle(const Duration(seconds: 3));
  expect(find.byType(MaterialApp), findsOneWidget);
}
```

### Navigation
```dart
Future<void> whenINavigateToSettings(WidgetTester tester) async {
  final settingsTab = find.text('Settings');
  await tester.tap(settingsTab);
  await tester.pumpAndSettle();
}
```

### Toggling Switches
```dart
Future<void> andIToggleTheSwitch(WidgetTester tester) async {
  final switchWidget = find.byKey(const Key('mySwitch'));
  await tester.tap(switchWidget);
  await tester.pumpAndSettle();
}
```

### Verifying State
```dart
Future<void> thenTheFeatureShouldBeEnabled(WidgetTester tester) async {
  final switchWidget = tester.widget<SwitchListTile>(
    find.byKey(const Key('mySwitch')),
  );
  expect(switchWidget.value, true);
}
```

## Troubleshooting

### Test Times Out
- Increase pump and settle duration
- Check for infinite animations
- Verify async operations complete

### Widget Not Found
- Add `await tester.pumpAndSettle()` before finding
- Check widget keys are correct
- Verify navigation completed

### State Not Updated
- Ensure `pumpAndSettle` is called after state changes
- Check that setState is being called in the widget
- Verify provider updates are triggering rebuilds

## Resources

- [BDD Widget Test Package](https://pub.dev/packages/bdd_widget_test)
- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Gherkin Syntax](https://cucumber.io/docs/gherkin/)
- [Widget Testing Best Practices](https://docs.flutter.dev/cookbook/testing/widget/introduction)

## Example: Complete BDD Test

See `integration_test/theme_toggle_test.dart` for a complete, working example of:
- Multiple test scenarios
- Proper step implementation
- State verification
- Navigation handling
- Theme persistence testing
