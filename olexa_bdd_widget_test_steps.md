# BDD Widget Test Implementation Guide

## Overview

This guide provides step-by-step instructions for implementing BDD (Behavior-Driven Development)
widget tests using the `bdd_widget_test` package in the Memverse Flutter project.

**Estimated Coverage with Current BDD Tests: 75-85%**

- The existing 3 feature files cover authentication flow, verse input/validation, and UI elements
- Happy path scenarios should hit most of the core application logic
- Missing mainly error handling, network failures, and bootstrap/configuration code
- Simple app architecture means high coverage achievable with basic scenarios

## Prerequisites

- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions
- The Memverse project cloned and set up

## Step 1: Add Dependencies

Add the following to your `pubspec.yaml`:

```yaml
dev_dependencies:
  bdd_widget_test: ^1.6.1
  build_runner: ^2.4.12
  flutter_test:
    sdk: flutter
```

Run:

```bash
flutter pub get
```

## Step 2: Create Feature Files

Feature files are located in `integration_test/` directory and use `.feature` extension.

### Current Feature Files:

- `authentication_bdd_test.feature` - Login/logout functionality
- `verse_practice_bdd_test.feature` - Verse reference practice
- `app_ui_bdd_test.feature` - UI elements and navigation

### Feature File Syntax Rules:

1. Use curly braces `{}` for parameters: `I see {'text'}` or `I tap {Icons.add}`
2. Start with `Feature:` declaration
3. Use `Background:` for common setup steps
4. Each `Scenario:` represents a test case
5. Use `Given`, `When`, `Then`, `And` keywords
6. Parameters must be valid Dart code within `{}`

## Step 3: Generate Test Files

Run the build runner to generate Dart test files from feature files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or for continuous watching:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Step 4: Implement Step Definitions

After generation, you'll find a `step/` directory with step definition files. Edit these to
implement the actual test logic:

### Common Step Implementations:

#### Authentication Steps:

```dart
// step/i_enter_into_login_username_field.dart
Future<void> iEnterIntoLoginUsernameField(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(const ValueKey('login_username_field')), text);
}

// step/i_tap_login_button.dart
Future<void> iTapLoginButton(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('login_button')));
  await tester.pumpAndSettle();
}
```

#### Verse Practice Steps:

```dart
// step/i_enter_into_reference_input_field.dart
Future<void> iEnterIntoReferenceInputField(WidgetTester tester, String text) async {
  final textFields = find.byType(TextField);
  await tester.enterText(textFields.last, text);
}

// step/i_tap_submit_button.dart
Future<void> iTapSubmitButton(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('submit-ref')));
  await tester.pumpAndSettle();
}
```

## Step 5: Build Configuration

Create or update `build.yaml` in your project root:

```yaml
targets:
  $default:
    builders:
      bdd_widget_test|featureBuilder:
        options:
          stepDirectoryName: step
          externalSteps:
            - package:bdd_widget_test/step/i_see_text.dart
            - package:bdd_widget_test/step/i_dont_see_text.dart
            - package:bdd_widget_test/step/i_tap_text.dart
            - package:bdd_widget_test/step/i_see_icon.dart
            - package:bdd_widget_test/step/i_tap_icon.dart
            - package:bdd_widget_test/step/i_enter_into_input_field.dart
```

## Step 6: Running BDD Tests

### Run All BDD Tests:

```bash
flutter test integration_test/
```

### Run Specific Feature:

```bash
flutter test integration_test/authentication_bdd_test.dart
```

### Run with Coverage:

```bash
flutter test --coverage integration_test/
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Step 7: What to Look For

### Successful Test Indicators:

- ✅ All scenarios pass
- ✅ No widget finder errors
- ✅ Proper state transitions (login → main screen)
- ✅ UI elements appear/disappear as expected
- ✅ Text validation works correctly

### Common Issues to Watch:

- ❌ Widget not found errors
- ❌ Timeout issues during pumping
- ❌ State not updating properly
- ❌ Missing test data setup
- ❌ Async operations not completing

### Debug Commands:

```bash
# Verbose test output
flutter test --reporter expanded integration_test/

# Debug specific test
flutter test integration_test/authentication_bdd_test.dart --plain-name "Successful login"
```

## Step 8: Coverage Analysis

### Expected Coverage from Current BDD Tests:

#### High Coverage Areas (85-95%):

- **Authentication Flow**: Login, logout, validation
- **Main UI Elements**: App bar, buttons, text fields
- **Verse Input Validation**: Empty/invalid format checking
- **Basic Navigation**: Screen transitions
- **Core App Logic**: Verse processing, answer feedback

#### Medium Coverage Areas (60-80%):

- **State Management**: Provider state changes
- **Error Handling**: Basic validation messages
- **Widget Interactions**: Form submissions, button taps

#### Low Coverage Areas (20-40%):

- **Network Error Scenarios**: Connection failures, API errors
- **Bootstrap/Configuration**: App initialization code
- **Edge Cases**: Unusual input formats, complex error states

### Estimated Total Coverage: **75-85%**

## Step 9: Missing Test Coverage

### Critical Missing Areas:

1. **Network Error Scenarios**
   ```gherkin
   Scenario: Network failure during login
     Given the app is running
     And network is unavailable
     When I attempt to login
     Then I see network error message
   ```

2. **Data Persistence Tests**
   ```gherkin
   Scenario: App state persists after restart
     Given I have answered verses
     When I restart the app
     Then my history is preserved
   ```

3. **Complex Verse Scenarios**
   ```gherkin
   Scenario Outline: Various verse reference formats
     When I enter <reference> into reference input field
     Then I see <result> feedback
     Examples:
       | reference | result |
       | 'Col 1:17' | 'Correct!' |
       | 'Colossians 1:17' | 'Correct!' |
       | 'col 1:17' | 'Correct!' |
   ```

4. **Timer and Async Operations**
   ```gherkin
   Scenario: Automatic verse progression
     When I submit correct answer
     And I wait 2 seconds
     Then next verse loads automatically
   ```

## Step 10: Advanced Configuration

### Custom Step Definitions:

Create domain-specific steps for your app:

```dart
// step/custom/i_am_logged_in_as.dart
Future<void> iAmLoggedInAs(WidgetTester tester, String username) async {
  // Check if already logged in and logout if necessary
  if (find
      .byIcon(Icons.logout)
      .evaluate()
      .isNotEmpty) {
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
  }

  // Now perform login
  await tester.enterText(find.byKey(const ValueKey('login_username_field')), username);
  await tester.enterText(find.byKey(const ValueKey('login_password_field')), 'fixmeplaceholder');
  await tester.tap(find.byKey(const ValueKey('login_button')));
  await tester.pumpAndSettle();

  // Wait for login to complete
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}
```

### Test Data Management:

```dart
// test/fixtures/test_data.dart
class TestVerseData {
  static const correctAnswers = {
    'He is before all things': 'Col 1:17',
    'It is for freedom': 'Gal 5:1',
  };
}
```

## Step 11: CI/CD Integration

### GitHub Actions Example:

```yaml
- name: Run BDD Tests
  run: |
    flutter test integration_test/ --coverage
    genhtml coverage/lcov.info -o coverage/html

- name: Upload Coverage
  uses: codecov/codecov-action@v3
  with:
    file: coverage/lcov.info
```

## Step 12: Maintenance and Best Practices

### Feature File Best Practices:

1. Keep scenarios focused and independent
2. Use meaningful scenario names
3. Avoid UI implementation details
4. Focus on business behavior
5. Use data tables for multiple test cases

### Step Definition Best Practices:

1. Keep steps atomic and reusable
2. Use proper wait mechanisms (`pumpAndSettle()`)
3. Add meaningful error messages
4. Handle async operations properly
5. Use proper widget finders

### Debugging Tips:

```dart
// Add debug prints in step definitions
print
('Current widget tree: ${tester.allWidgets}');

// Take screenshots for failed tests
await tester.binding.takeScreenshot('test_failure.png');

// Use specific finders
find.byKey(const ValueKey('specific_widget'))
find
    .
byType
(
SpecificWidgetType
)
```

## Expected Results

With proper implementation of these BDD tests, you should achieve:

- **Test Coverage**: 75-85% overall
- **UI Coverage**: 85%+ for implemented features
- **Business Logic Coverage**: 60%+ for core functionality
- **Error Handling Coverage**: 45%+ for common error scenarios

The tests will provide confidence in:

- User authentication workflows
- Basic verse practice functionality
- UI element presence and behavior
- Form validation and error handling
- State management during user interactions

## Next Steps

1. Implement the missing test scenarios identified above
2. Add performance and load testing scenarios
3. Create visual regression tests for UI consistency
4. Add accessibility testing scenarios
5. Implement E2E tests with real backend integration

