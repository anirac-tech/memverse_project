# Add Feedback Feature with Share Dialog Integration

## Description

This PR adds a robust feedback collection system to the Memverse app, allowing users to submit
feedback directly from the application. The implementation includes screenshot capture and sharing
capabilities via the native share dialog on both Android and iOS platforms.

## Changes Made

- Added the `feedback` package (v3.1.0) for capturing screenshots and text feedback
- Added `share_plus` (v11.0.0) for triggering native share dialogs with the feedback content
- Added `path_provider` (v2.1.3) for temporary screenshot storage
- Implemented BetterFeedback wrapper in the App widget
- Added a feedback button to the MemversePage with proper error handling
- Created a separate handler for feedback submissions with appropriate logging
- Added coverage ignores for platform-specific code
- Created documentation for Jira integration and future Bugsee integration options
- Fixed dependency conflicts between share_plus and build_runner

## Screenshots

*[Screenshots of the feedback feature will go here]*

## How to Test

1. Run the app on an Android or iOS device
2. Tap the feedback icon in the MemversePage app bar
3. Draw on the screen to highlight areas and enter feedback text
4. Submit the feedback
5. Verify the device's native share dialog appears with:
    - The screenshot attached
    - The feedback text prefilled
    - "Memverse App Feedback" as the subject (especially visible in email apps)

## Technical Details

- Uses `BetterFeedback.of(context).show()` for capturing feedback
- Saves screenshots to temporary directory using path_provider
- Uses share_plus to trigger the native share dialog
- Includes proper error handling and fallbacks for failures
- Compatible with Android and iOS sharing mechanisms

## Dependencies

- Added `feedback: ^3.1.0`
- Added `path_provider: ^2.1.3`
- Added `share_plus: ^11.0.0` (specifically v11+ to avoid conflicts with build_runner)

## Testing

- Added widget tests for the feedback button presence
- Added coverage exclusions for platform-specific code that can't be effectively unit tested
- All existing tests pass with coverage maintained at >87%

## Documentation

- Created `feedback_setup_jira.md` with instructions for Jira integration
- Created `todo_bugsee_android.md` and `todo_bugsee_ios.md` for future enhancements

## Notes for Reviewers

- The share dialog's appearance and behavior will vary between devices and operating systems
- Added debug logging statements to help troubleshoot any platform-specific issues
- The PR enforces share_plus v11.0.0+ to avoid dependency conflicts with build_runner

## Checklist

- [x] Code follows the project's style guidelines
- [x] Added appropriate documentation
- [x] Added/updated tests
- [x] All CI checks pass
- [x] Verified working on Android
- [x] Verified working on iOS