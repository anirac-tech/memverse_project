# Memverse Integration Tests

This directory contains integration tests for the Memverse app using Flutter's integration_test
package.

## Running Integration Tests

### On Device/Emulator

```bash
# Run all integration tests
flutter test integration_test

# Run specific integration test
flutter test integration_test/signup_test.dart
```

### With Screenshots

```bash
flutter drive \
  --driver=test_driver/integration_test_driver.dart \
  --target=integration_test/signup_test.dart
```

## BDD-Style Tests

We use a BDD-style approach for our integration tests:

1. **Features files**: Located in `features/` directory
2. **Test implementation**: BDD-style test implementation in `signup_test.dart`

### Running BDD Tests

```bash
# Run the BDD signup test
flutter test integration_test/signup_test.dart
```

## Test Files

- `signup_test.dart` - BDD-style test for the signup flow
- `features/signup.feature` - Gherkin feature file for signup
- `util/test_app_wrapper.dart` - Utility for creating test app instances

## Testing Strategy

These tests verify that the app behaves correctly from a user perspective, validating:

1. **User Interface** - Forms, validation, and UI state transitions
2. **Navigation** - Flow between screens works as expected
3. **Error Handling** - Proper user feedback for error conditions

## Test Naming Conventions

Tests are organized using descriptive BDD-style naming:

- **Given**: Setup for the test
- **When**: Actions performed
- **Then**: Assertions and verifications

## Coverage Goals

- Aim for 100% line coverage of happy path flows
- Test all validation scenarios
- Verify error states and user feedback

## Related Testing Resources

- Unit/Widget tests: See `test/` directory
- End-to-end tests: See `maestro/` directory for Maestro UI tests
