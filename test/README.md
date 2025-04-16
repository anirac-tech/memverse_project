# Testing in Memverse

This directory contains tests for the Memverse application.

## Test Structure

- `test/src/common/`: Common test utilities and helpers
- `test/src/features/`: Feature-specific tests organized by feature
    - `auth/`: Authentication feature tests
    - `verse/`: Verse management feature tests
- `integration_test/`: Integration tests for full user flows

## Running Tests

### Running All Tests

```bash
flutter test
```

### Running Widget/Unit Tests

```bash
flutter test test/
```

### Running Integration Tests

```bash
flutter test integration_test/
```

### Running Golden Tests

```bash
# Update golden files (baseline images)
flutter test --update-goldens --tags golden

# Run golden tests without updating
flutter test --tags golden
```

### Generating Golden Test Report

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