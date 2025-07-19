# Memverse Test Suite

This directory contains unit tests and widget tests for the Memverse app.

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## Directory Structure

- `features/` - Tests organized by feature
    - `auth/` - Authentication-related tests
        - `signup_page_test.dart` - Widget tests for signup page
- `test/src/common/`: Common test utilities and helpers
- `test/src/features/`: Feature-specific tests organized by feature
    - `auth/`: Authentication feature tests
    - `verse/`: Verse management feature tests
- `integration_test/`: Integration tests for full user flows

## Test Guidelines

1. **Coverage Goals**:
    - Aim for 100% line coverage of happy path flows
    - Validate all form inputs and error states
    - Test UI state transitions (loading, success, error)

2. **Naming Conventions**:
    - Use descriptive test names that explain what's being tested
    - Format: `should [expected behavior] when [condition]`

3. **Organization**:
    - Use `group` to organize related tests
    - Minimize repeated setup with `setUp` and `tearDown`

## Mock Strategy

We use fake implementations (like `FakeUserRepository`) to isolate tests from external dependencies.
This approach is similar to Square's "JSON literals" pattern for testing.

## Running Widget/Unit Tests

```bash
flutter test test/
```

## Running Integration Tests

```bash
flutter test integration_test/
```

## Running Golden Tests

```bash
# Update golden files (baseline images)
flutter test --update-goldens --tags golden

# Run golden tests without updating
flutter test --tags golden
```

## Generating Golden Test Report

After running golden tests, you can generate an HTML report to compare any differences:

```bash
./scripts/generate_golden_report.sh
```

This will create a report in `golden_report/index.html` showing visual comparisons between expected
and actual UI.

## Golden Tests

Golden tests are used to catch unintended visual changes in the UI. They work by:

1. Capturing a screenshot of a widget or screen
2. Comparing it against a baseline image (the "golden" file)
3. Failing if there are differences between the two

### Workflow

1. Create a golden test for a UI component
2. Run with `--update-goldens` to generate the baseline image
3. Commit both the test and the golden file
4. When making UI changes, run the golden tests to see if they fail
5. If the changes are intentional, update the golden files

## Pre-commit Hook

The project includes a pre-commit hook that:

1. Runs all tests
2. Updates golden files if needed
3. Reports any differences without failing the commit

To install the hook:

```bash
./scripts/setup_git_hooks.sh
```

## Related Testing Resources

- Integration tests: See `integration_test/` directory
- End-to-end tests: See `maestro/` directory for Maestro UI tests
