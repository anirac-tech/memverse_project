<!--
  Thanks for contributing!

  Provide a description of your changes below and a general summary in the title
-->

## Description

# Implement AppLogger and Enforce Logging Standards

## Jira Tickets

- [MEM-112](https://anirac-tech.atlassian.net/browse/MEM-112): Implement logging standards and
  AppLogger
- [MEM-102](https://anirac-tech.atlassian.net/browse/MEM-102): Documentation for app flavors

## Changes

This PR adds comprehensive logging standards to the Memverse app using the AppLogger utility,
ensuring consistent logging across different app flavors, and provides detailed documentation about
the app's flavor system.

### Features Added

- **AppLogger Implementation**: Custom logging utility that leverages kDebugMode for conditional
  logging
- **Pre-commit Hook Enhancement**: Added check for prohibited logging methods (debugPrint, log)
- **CI Pipeline Check**: New job in main.yaml workflow that ensures AppLogger usage
- **Documentation**:
    - Updated README.md with logging standards
    - Created detailed documentation for app flavors (users and developers)
    - Updated CONTRIBUTING.md with guidelines on logging and flavors

### Technical Details

- AppLogger methods conditionally log based on debug/release mode
- Pre-commit hook uses grep to catch prohibited logging methods
- CI workflow includes a dedicated job for checking logging standards
- All documentation includes external references and best practices

## Testing Checklist

- [ ] Verified AppLogger properly logs in debug mode only
- [ ] Tested pre-commit hook catches invalid logging:
    - [ ] Tested with `debugPrint()` usage
    - [ ] Tested with `log()` usage
- [ ] Confirmed CI pipeline fails when prohibited logging methods are used
- [ ] Confirmed all documentation is accurate and helpful

## Documentation

- Added documentation about flavors:
    - `flavors_info_for_users.md`: End-user explanation of app versions
    - `flavor_info_for_devs.md`: Technical implementation details for developers
- Updated `README.md` with logging standards and flavor information
- Updated `CONTRIBUTING.md` with development guidelines for logging