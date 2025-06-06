<!--
  Thanks for contributing!

  Provide a description of your changes below and a general summary in the title
-->

## Description

# Implement PostHog Analytics Integration with Service Architecture

## Jira Tickets

- [MEM-146](https://anirac-tech.atlassian.net/browse/MEM-146): Android POC for session replay and
  basic analytics

## Changes vs. Origin/Main

This branch implements comprehensive PostHog analytics integration with a clean service-oriented
architecture:

- **Analytics Service Architecture**:
    - Created abstract `AnalyticsService` interface with `init()` and `track()` methods
    - Implemented `PostHogAnalyticsService` with full PostHog Flutter SDK integration
    - Added `LoggingAnalyticsService` and `NoOpAnalyticsService` for testing/debug
    - Integrated with Riverpod dependency injection via `analyticsServiceProvider`

- **PostHog Integration Features**:
    - Session replay functionality with configurable masking options
    - Automatic lifecycle event tracking (app opened, backgrounded, etc.)
    - Environment variable support for PostHog API key (`POSTHOG_MEMVERSE_API_KEY`)
    - Platform-specific configuration for web and mobile
    - Comprehensive error handling and graceful fallbacks

- **Automatic Property Tracking**:
    - `app_flavor`: 'development' (flavor identification)
    - `debug_mode`: true/false (build configuration)
    - `platform`: 'web', 'android', 'ios', etc. (platform detection)
    - `is_emulator`: true/false (Android emulator detection via system properties)
    - `is_simulator`: true/false (iOS simulator detection via environment variables)

- **Web-Specific Enhancements**:
    - Dual SDK approach (JavaScript + Flutter) for comprehensive web tracking
    - Session replay specifically configured for web platform
    - Web performance tracking methods in service interface

- **Comprehensive Event Tracking Interface**:
    - User authentication events (login, logout, failures)
    - Verse practice tracking (correct, incorrect, nearly correct answers)
    - Navigation and user interaction events
    - Form validation and password visibility tracking
    - Feedback and practice session analytics

- **Clean Architecture Benefits**:
    - Removed direct PostHog dependencies from main.dart
    - Centralized analytics configuration and initialization
    - Easy testing with service mocks and no-op implementations
    - Separation of concerns between app startup and analytics setup

## Testing Checklist

- [ ] Verified analytics service initializes correctly with valid API key
- [ ] Tested error handling when PostHog API key is missing
- [ ] Confirmed session replay functionality on both web and mobile platforms
- [ ] Verified automatic property registration (flavor, debug_mode, platform, emulator/simulator)
- [ ] Tested platform detection logic for Android emulators and iOS simulators
- [ ] Confirmed analytics events are captured and sent to PostHog dashboard
- [ ] Verified web-specific JavaScript SDK integration works correctly
- [ ] Tested service architecture with different implementations (PostHog, Logging, NoOp)
- [ ] Confirmed graceful fallbacks when analytics initialization fails
- [ ] Verified analytics tracking doesn't crash app on errors

## Outstanding Issues / Next Steps

- Monitor PostHog analytics dashboard to ensure events and properties are being received correctly
- Consider adding more granular event tracking for key user interactions
- Evaluate performance impact of session replay on mobile devices, especially on lower-end hardware
- Add analytics integration tests to verify service behavior in different scenarios
- Consider implementing analytics batching for improved performance
- Add flavor-specific analytics configurations for production vs development environments
