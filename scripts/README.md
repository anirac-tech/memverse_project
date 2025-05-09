# Scripts Directory

This directory contains various scripts used for development, testing, and CI/CD pipelines.

## Logging Standards Check

The `check_logging_standards.py` script enforces the project's logging standards by detecting and
fixing prohibited logging methods.

### Overview

- Detects usage of prohibited logging methods (`debugPrint()` from Flutter and `log()` from dart:
  developer)
- Automatically fixes violations in local development by replacing them with `AppLogger.d()`
- Fails CI builds when violations are found
- Includes test coverage as examples and documentation

### Usage

#### Local Development

For local development, use the `--mode local` flag. Add `--auto-fix` to automatically fix
violations:

    python3 scripts/check_logging_standards.py --mode local --auto-fix

#### CI Pipeline

For CI pipelines, use the `--mode ci` flag, which will fail when violations are found:

    python3 scripts/check_logging_standards.py --mode ci

### Test Coverage and Examples

Run the test suite with:

    python3 scripts/test_check_logging_standards.py

The tests serve as documentation and examples for how the logging standards checker works.

## Other Scripts

- `check_before_commit.sh`: Runs various checks before committing, including the logging standards
  check
- `widget_tests.sh`: Runs widget tests
- `integration_tests.sh`: Runs integration tests

```