# Gemini Answers - Level 1 Questions

This file repeats the questions from `questions-L1.md` and provides answers based on the current
branch state.

## Logging Standards

1. **Question**: Why do we need to use AppLogger instead of direct debugPrint or log calls? Wouldn't
   it be simpler to use the built-in methods?

   **Answer**: Using `AppLogger` provides several benefits over standard `debugPrint`/`log`:
    * **Consistency**: Ensures all log messages follow a standard format.
    * **Conditional Logging**: `AppLogger` is configured to *only* output logs when the app is
      running in `kDebugMode`. This prevents debug messages from appearing in production builds,
      improving performance and security.
    * **Centralized Control**: If we need to change logging behavior (e.g., add timestamps, change
      output format, send logs remotely), we only need to modify the `AppLogger` implementation.
    * **Enforcement**: Using a custom utility allows us to enforce its usage through tools like
      pre-commit hooks, CI checks, and custom lint rules, ensuring everyone follows the standard.
    * **(See `logging.md` for more details)**

2. **Question**: How can I remember to use AppLogger.d() instead of debugPrint() when I'm used to
   Flutter's standard logging?

   **Answer**: There are multiple layers of help:
    * **Pre-commit Hook**: If you forget and try to commit `debugPrint` or ` log`, the commit will
      fail, and the script will attempt to auto-fix it for you (you still need to review and
      re-stage the fix).
    * **CI Check**: The pipeline will also fail if prohibited methods are detected.
    * **Custom Lint Rules (Future)**: Once the dependency issues are resolved, the custom lint rules
      will provide immediate feedback in your IDE with errors and quick fixes.
    * **Muscle Memory**: Over time, using `AppLogger` will become more natural as you work within
      the project standards.
    * **(See `logging.md` and `CONTRIBUTING.md` for setup and usage)**

## Flavor System

3. **Question**: What's the difference between the development, staging, and production flavors in
   practical terms?

   **Answer**:
    * **Development (`[DEV] Memverse`)**: Used for daily coding. Connects to test servers, might
      have experimental features enabled, has more logging, and a distinct app icon/name so you
      don't mix it up.
    * **Staging (`[STG] Memverse`)**: Used for testing before release. Connects to staging servers (
      like production, but with test data), should be stable, includes analytics/bug reporting, and
      has its own distinct icon/name. Distributed internally (e.g., TestFlight).
    * **Production (`Memverse`)**: The final version released to users via app stores. Connects to
      live servers, is optimized, has minimal logging, and the standard app icon/name.
    * **(See `flavors_info_for_users.md` and `flavor_info_for_devs.md` for details)**

4. **Question**: Do I need to set up all three flavors on my local development environment to
   contribute to the project?

   **Answer**: Generally, no. For most development tasks, you'll primarily use the **development**
   flavor. You only need to run other flavors if you're specifically testing configuration
   differences or preparing for a release. The `README.md` provides the commands to run each
   specific flavor if needed.

## Project Structure

5. **Question**: Where should I add new files when implementing a feature? I notice there are
   different folders like "features", "utils", etc.

   **Answer**: The project generally follows a feature-first structure. New UI screens, related
   logic (providers/state), and data handling for a specific feature (e.g., user authentication)
   usually go within a dedicated subfolder inside `lib/src/features/`. Common utilities or services
   shared across features go into `lib/src/utils/` or `lib/src/services/` respectively. Check
   `CONTRIBUTING.md` (if updated with this detail) or existing features for examples.

6. **Question**: How does localization work in the app? I see ARB files but I'm not sure how to add
   new translated strings.

   **Answer**: The app uses Flutter's built-in internationalization (i10n) based on ARB (`.arb`)
   files in `lib/l10n/arb/`.
    1. Add the new string (key, value, description) to the base file (`app_en.arb`).
    2. Add the translated value to the other language files (e.g., `app_es.arb`).
    3. Flutter automatically generates the necessary Dart code (`app_localizations.dart` and related
       files).
    4. Use the string in your code via `AppLocalizations.of(context).yourStringKey`.

    * **(The `README.md` file in this branch was updated with a section on Internationalization
      detailing these steps.)**

## Development Workflow

7. **Question**: How do I run tests to make sure my changes don't break existing functionality?

   **Answer**: The project has several ways to run tests:
    * `flutter test`: Runs unit and widget tests.
    * `flutter test --coverage`: Runs tests and generates a coverage report.
    * `flutter test integration_test`: Runs integration tests (requires a device/emulator).
    * `./scripts/check_before_commit.sh`: Runs fixes, formatting, analysis, and tests – this is the
      recommended check before committing.
    * Specific test files can be run by providing their path: `flutter test path/to/your_test.dart`.

8. **Question**: The pre-commit hook prevents me from committing code with debugPrint. How can I
   temporarily bypass this check when debugging?

   **Answer**: While not generally recommended, you can bypass the pre-commit hook for a specific
   commit using the `--no-verify` flag:
   ```bash
   git commit -m "Temporary commit with debug statements" --no-verify 
   ```
   **Remember to remove the `debugPrint`/`log` calls and commit normally before pushing or creating
   a PR.** Using `AppLogger.d()` is the preferred way even for temporary debugging, as it follows
   the project standard.

## Specific Code Questions

9. **Question**: What's the difference between AppLogger.d(), AppLogger.i(), AppLogger.e(), etc.?

   **Answer**: These methods correspond to different standard logging levels, indicating the
   severity or purpose of the message:
    * `t`: Trace (most verbose, detailed execution flow)
    * `d`: Debug (general development messages)
    * `i`: Info (informational messages, start/end of processes)
    * `w`: Warning (potential issues that don't stop execution)
    * `e`: Error (problems that caused an operation to fail, usually includes an error object and
      stack trace)
    * `f`: Fatal (critical errors causing the app to crash)
      Use the level that best describes the nature of the message. For general debugging, `d` is
      common. For caught exceptions, `e` is appropriate.
    * **(See `logging.md` for a table of methods)**

10. **Question**: When I use AppLogger.e(), what should I include as the error and stackTrace
    parameters?

    **Answer**: When you catch an exception in a `try-catch` block, the `catch` clause provides the
    error object (often named `e`) and the `StackTrace` object (often named `stackTrace` or
    `stack`). Pass these directly to `AppLogger.e()`:
    ```dart
    try {
      // Risky code
    } catch (e, stackTrace) {
      AppLogger.e('Something went wrong during operation X', e, stackTrace);
    }
    ```
    This provides valuable context for debugging errors.

## PWA-related Questions

11. **Question**: How can I test the offline functionality of the PWA locally?

    **Answer**:
    1. Build and run the web version: `flutter run -d chrome --web-renderer canvaskit`
    2. Install the app via the browser's install prompt.
    3. Navigate through the parts of the app you want to test offline.
    4. Open Chrome DevTools (F12 or Right-click -> Inspect).
    5. Go to the "Network" tab.
    6. Check the "Offline" checkbox.
    7. Try using the app. Sections you visited should still be available. Check the "Application"
       tab -> "Storage" to see cached data (IndexedDB, Cache Storage).

    * **(See `pwa_technical.md` for more details)**

12. **Question**: What's the easiest way to demonstrate the PWA installation feature to other team
    members?

    **Answer**: Creating a short screen recording is often best:
    * Use a tool like [Loom](https://www.loom.com/) (as suggested in `demo_pwa.md`).
    * Record yourself installing the app from the browser (both desktop and mobile, possibly using
      phone mirroring).
    * Briefly show the app icon on the home screen/app list.
    * Keep the language simple and non-technical.
    * Alternatively, share the step-by-step instructions and screenshots from `pwa_user.md`.
    * **(See `demo_pwa.md` for detailed instructions)**