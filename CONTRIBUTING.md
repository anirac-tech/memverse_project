# Contributing to Memverse

Thank you for contributing to Memverse! This document provides guidelines and instructions for
development practices.

## Setting Up Development Environment

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Set up the git hooks (see below)

## Git Hooks

Memverse uses git hooks to ensure code quality before commits. To set up the pre-commit hook:

## Logging

When logging in the application, please follow these guidelines:

- Use `AppLogger.e()` for error logging with proper error objects and stack traces
- Never use direct Flutter/Dart logging methods

The pre-commit hook will prevent commits with prohibited logging methods, and the CI pipeline will
also fail if any are detected.

For detailed information about logging standards, available methods, and enforcement tools, please
refer to the [Logging Standards and Tools](logging.md) documentation.

### Pre-commit Hooks

All developers are strongly encouraged to set up pre-commit hooks to ensure code quality and
consistency. Follow the setup instructions in the [Pre-commit Hooks](#pre-commit-hooks-1) section
below.
