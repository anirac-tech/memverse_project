# Gherkin BDD Tests Guide for Memverse

## Overview

This guide explains how we use Gherkin-style Behavior Driven Development (BDD) tests in the Memverse
project using the `bdd_widget_test` package.

## Why BDD Testing?

- Business-readable test cases that serve as living documentation
- Clear separation of test scenarios and implementation
- Reusable steps across different features
- Easy to maintain and understand test cases
- Natural language descriptions of application behavior

## Directory Structure

```
test/
├── bdd/
│   ├── features/         # Gherkin feature files
│   │   ├── login.feature
│   │   └── verses.feature
│   └── step_definitions/ # Step implementation files
│       ├── login_steps.dart
│       └── verses_steps.dart
```

## Running Tests

### Running All BDD Tests

```bash
flutter test test/bdd/step_definitions/
```

### Running Specific Feature Tests

```bash
flutter test test/bdd/step_definitions/login_steps.dart
flutter test test/bdd/step_definitions/verses_steps.dart
```

### Running with Live Credentials

```bash
flutter test test/bdd/step_definitions/login_steps.dart \
  --dart-define=USERNAME=$MEMVERSE_USERNAME \
  --dart-define=PASSWORD=$MEMVERSE_PASSWORD \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID
```

## Writing Feature Files

### Basic Structure

```gherkin
Feature: [Feature Name]
  As a [role]
  I want [feature]
  So that [benefit]

  Background:
    Given [common preconditions]

  Scenario: [scenario name]
    Given [precondition]
    When [action]
    Then [expected result]
```

### Best Practices

1. Use descriptive feature and scenario names
2. Keep scenarios focused and atomic
3. Use Background for common setup steps
4. Write scenarios from the user's perspective
5. Use consistent terminology
6. Include both happy and error paths

## Step Definitions

### Structure

```dart
import 'package:bdd_widget_test/bdd_widget_test.dart';

Future<void> main() async {
  group('Feature test', () {
    Future<void> setupApp(WidgetTester tester) async {
      // Setup code
    }

    testWidgets('Execute scenarios', (tester) async {
      // Test implementation
    });
  });
}
```

### Best Practices

1. Keep step definitions small and focused
2. Reuse steps across scenarios when possible
3. Use meaningful widget keys for reliable element finding
4. Handle asynchronous operations properly
5. Add appropriate error handling
6. Include meaningful assertions

## Environment Variables

The tests use environment variables for secure credentials:

- `MEMVERSE_USERNAME`: Test account username
- `MEMVERSE_PASSWORD`: Test account password
- `MEMVERSE_CLIENT_ID`: API client ID

See `test_setup.md` for detailed environment setup instructions.

## Common Issues and Solutions

### Test Failing to Find Widgets

- Ensure widget keys are correctly set in the app
- Use `tester.pumpAndSettle()` after actions that trigger animations
- Check if widgets are actually rendered (not hidden/disposed)

### Asynchronous Operation Issues

- Use `async/await` properly
- Add appropriate delays for network operations
- Handle timeouts gracefully

### Environment Variable Issues

- Verify environment variables are set correctly
- Check credentials are valid
- Ensure proper escaping of special characters

## Debugging Tips

1. Use `tester.printToConsole()` for debugging
2. Add screenshots at crucial points
3. Use the `--verbose` flag for detailed test output
4. Enable timeline logging for performance analysis

## Test Coverage

To generate and view test coverage:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Resources

- [bdd_widget_test Package](https://pub.dev/packages/bdd_widget_test)
- [Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)
- [Flutter Test Documentation](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)
- [BDD Testing Best Practices](https://cucumber.io/docs/bdd/better-gherkin/)

## FAQ

### Q: Why use BDD over traditional widget tests?

A: BDD provides better readability, maintainability, and serves as living documentation. It bridges
the gap between technical and non-technical stakeholders.

### Q: How to handle complex test scenarios?

A: Break them down into smaller, focused scenarios. Use Background steps for common setup and tags
for organization.

### Q: Can I mix BDD and traditional widget tests?

A: Yes! Use BDD for high-level behavior testing and traditional widget tests for detailed component
testing.

### Q: How to handle test data?

A: Use test fixtures, factory methods, or mock data generators. Keep test data separate from test
logic.

### Q: How to maintain test stability?

A: Use stable widget keys, handle asynchronous operations properly, and avoid time-dependent tests.