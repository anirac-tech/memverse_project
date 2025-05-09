# Claude Answers - Level 1 Questions

This file repeats the questions from `questions-L1.md` and provides answers based on the current
branch state.

## Logging Standards

1. **Question**: Why do we need to use AppLogger instead of direct debugPrint or log calls? Wouldn't
   it be simpler to use the built-in methods?

   **Answer**: While built-in methods might seem simpler at first, AppLogger provides several
   important benefits:
    * **Centralized Control**: AppLogger lets us manage all logging through a single interface,
      making it easier to change behavior across the entire app.
    * **Release Safety**: AppLogger automatically disables logs in release builds via kDebugMode
      checks, preventing sensitive information from appearing in production.
    * **Standardized Format**: All logs follow a consistent format, making them easier to filter and
      understand.
    * **Future Extensibility**: If we need remote logging or crash reporting later, we can add it to
      AppLogger without changing call sites throughout the codebase.
    * **IDE Assistance**: All logging methods are well-documented with clear parameter requirements.

2. **Question**: How can I remember to use AppLogger.d() instead of debugPrint() when I'm used to
   Flutter's standard logging?

   **Answer**: Several systems are in place to help you remember:
    * **Pre-commit Hook**: The hook will catch any debugPrint or log calls and attempt to auto-fix
      them before allowing your commit.
    * **CI Checks**: The pipeline will fail if prohibited logging methods are found, providing file
      names and line numbers.
    * **Custom Lint Rules**: Once dependency issues are resolved, you'll get immediate feedback in
      your IDE with quick-fix options.
    * **Muscle Memory**: After using AppLogger consistently for a while, it will become second
      nature.
    * **Code Examples**: Looking at existing code will reinforce the pattern as AppLogger is used
      consistently.

## Flavor System

3. **Question**: What's the difference between the development, staging, and production flavors in
   practical terms?

   **Answer**: Each flavor serves a specific purpose in the app lifecycle:
    * **Development** (`[DEV]`): Used during active development with extra debugging capabilities,
      test servers, and a distinct app icon/name to avoid confusion with other versions.
    * **Staging** (`[STG]`): Mimics the production environment but with test data. Used for final
      testing and internal distribution (TestFlight, Firebase App Distribution) before releasing to
      users.
    * **Production**: The version released to users through app stores, with optimized performance,
      minimal logging, and connections to live production servers.

4. **Question**: Do I need to set up all three flavors on my local development environment to
   contribute to the project?

   **Answer**: No, for most development work, you only need to use the development flavor. The
   README provides commands to run each flavor if needed, but day-to-day development typically
   happens in the development environment. The CI/CD pipeline handles building other flavors for
   testing and distribution.

## Project Structure

5. **Question**: Where should I add new files when implementing a feature? I notice there are
   different folders like "features", "utils", etc.

   **Answer**: Follow these guidelines:
    * **New Feature**: Create a subdirectory in `lib/src/features/` for your feature with
      appropriate subfolders for UI, state management, and data.
    * **Shared Logic**: Place utilities and helpers in `lib/src/utils/` if they're used across
      multiple features.
    * **Services**: Add services that interface with external systems in `lib/src/services/`.
    * **Models**: Data classes go in `lib/src/models/` or within their specific feature folder if
      only used there.
    * **Extensions**: Place extension methods in `lib/src/extensions/`.
    * When in doubt, look at existing features with similar functionality and follow the established
      patterns.

6. **Question**: How does localization work in the app? I see ARB files but I'm not sure how to add
   new translated strings.

   **Answer**: The app uses Flutter's built-in localization system:
    1. Add your new string to `lib/l10n/arb/app_en.arb` with a key, value, and description.
    2. Add translations to other language files (e.g., `app_es.arb`) using the same key.
    3. Run `flutter gen-l10n` or let the build process generate the localization code.
    4. Access your string in code with `AppLocalizations.of(context).yourStringKey`.

   The app automatically handles selecting the right language based on device settings.

## Development Workflow

7. **Question**: How do I run tests to make sure my changes don't break existing functionality?

   **Answer**: The project has multiple test types and commands:
    * **All Tests**: Run `flutter test` for unit and widget tests.
    * **Coverage Report**: Use `flutter test --coverage` to generate a coverage report.
    * **Integration Tests**: Run `flutter test integration_test` with a connected device.
    * **Specific Tests**: Run individual test files with `flutter test path/to/test.dart`.
    * **Pre-commit Check**: Use `./scripts/check_before_commit.sh` to run analysis, formatting, and
      tests before committing.

   Each test type helps verify different aspects of your code, from individual functions to full app
   interactions.

8. **Question**: The pre-commit hook prevents me from committing code with debugPrint. How can I
   temporarily bypass this check when debugging?

   **Answer**: While best practice is to use AppLogger.d() even for temporary debugging, you can:
    1. Use `git commit --no-verify` to bypass the pre-commit hook entirely (not recommended).
    2. Temporarily comment out the logging check portion in `scripts/check_before_commit.sh` for
       your development session.
    3. Run `git add` without committing until you're ready to clean up your debug statements.

   Remember to clean up and use AppLogger.d() before your final commit, as the CI pipeline will
   still enforce the standard.

## Specific Code Questions

9. **Question**: What's the difference between AppLogger.d(), AppLogger.i(), AppLogger.e(), etc.?

   **Answer**: Each method represents a different logging level with specific purposes:
    * **t()**: Trace - Most detailed level, for tracing execution flow.
    * **d()**: Debug - General development information, variable values.
    * **i()**: Info - Important application events, process start/end notifications.
    * **w()**: Warning - Potential issues that don't interrupt execution.
    * **e()**: Error - Problems that caused operations to fail, includes error object and stack
      trace.
    * **f()**: Fatal - Critical errors that might crash the app or require immediate attention.

   Use the level that best describes your message's importance and nature.

10. **Question**: When I use AppLogger.e(), what should I include as the error and stackTrace
    parameters?

    **Answer**: When catching exceptions, include both the error object and stack trace:

    ```
    try {
      // Code that might throw
    } catch (e, stackTrace) {
      AppLogger.e('Failed to load user data', e, stackTrace);
      // Error handling
    }
    ```

    This provides complete context for debugging. If you don't have an error object (e.g., for logic
    errors), you can pass `null` for the error and omit the stack trace, but including both whenever
    available creates the most useful logs.

## PWA-related Questions

11. **Question**: How can I test the offline functionality of the PWA locally?

    **Answer**: Follow these steps:
    1. Build and serve the web app: `flutter run -d chrome --web-renderer canvaskit`
    2. Use the app normally to cache necessary resources
    3. In Chrome DevTools (F12), go to the Network tab and check "Offline"
    4. Continue using the app to verify offline functionality
    5. Check IndexedDB and Cache Storage in the Application tab to see stored data
    6. For comprehensive testing, install the PWA via Chrome's install button and test after
       restarting

12. **Question**: What's the easiest way to demonstrate the PWA installation feature to other team
    members?

    **Answer**: Create a brief demonstration using these approaches:
    1. **Screen Recording**: Use a tool like Loom to record yourself:
        - Opening the app in a browser
        - Clicking the install button in the address bar
        - Showing the app icon on your home screen/desktop
        - Opening the installed app and demonstrating it works like a native app
    2. **Step-by-Step Guide**: Share screenshots of each installation step with annotations
    3. **Live Demo**: During a meeting, share your screen and walk through the installation process

    Keep the demonstration simple and focused on the end-user experience rather than technical
    details.