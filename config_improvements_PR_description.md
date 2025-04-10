# Configuration And Testing Improvements

## Summary

This PR introduces a robust configuration management system and enhances the testing infrastructure,
making the codebase more reliable and easier to maintain. The implementation ensures that required
environment variables are properly validated and provides clear error messages when configuration is
missing.

## Key Improvements

### 1. Centralized Configuration Management

- Created a shared configuration system with a single source of truth
- Added `project_config.sh` to store shared configuration values
- Implemented a system for extracting configuration values in GitHub Actions workflows
- Eliminated duplicate configuration values across build scripts and CI/CD pipelines

### 2. Enhanced Error Handling

- Added proper validation for required environment variables
- Created user-friendly error screens when critical configuration is missing
- Provided clear instructions on how to run the app with proper configuration
- Improved logging for configuration-related issues

### 3. Code Quality Improvements

- Fixed analyzer issues related to const usage and redundant arguments
- Improved type safety throughout the codebase
- Enhanced coverage thresholds and excluded generated files
- Made all tests pass with 99.3% coverage

### 4. Build Process Enhancements

- Improved `check_before_commit.sh` script with better coverage validation
- Enhanced GitHub Actions workflow to extract configuration from source code
- Added consistent code formatting rules across environments
- Fixed issues with test coverage calculation

## Technical Details

- Created ConfigurationErrorWidget to provide helpful error messages
- Modified bootstrap.dart to validate CLIENT_ID early in the startup process
- Improved error handling and error UI for missing configuration
- Fixed issues with argument values in auth providers
- Implemented a more robust method to check coverage thresholds

## Testing

- All tests now pass with 99.3% coverage
- Added better error handling and validation in tests
- Fixed issues with test setup documentation

## Next Steps

- Consider adding more configuration values to the centralized system
- Improve test coverage for edge cases in configuration handling
- Enhance error messages with more context-sensitive information
- Consider adding automated validation for the config file format

This PR ensures better consistency between local development and CI/CD environments by having a
single source of truth for configuration values like coverage thresholds.