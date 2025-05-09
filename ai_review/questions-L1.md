# Level 1 Questions and Concerns

These are beginner-friendly questions about the Memverse codebase that junior developers might have.

## Logging Standards

1. **Question**: Why do we need to use AppLogger instead of direct debugPrint or log calls? Wouldn't
   it be simpler to use the built-in methods?

   **Context**: The codebase enforces AppLogger usage through pre-commit hooks, CI checks, and lint
   rules.

2. **Question**: How can I remember to use AppLogger.d() instead of debugPrint() when I'm used to
   Flutter's standard logging?

   **Context**: It's easy to fall back to familiar patterns when writing code quickly.

## Flavor System

3. **Question**: What's the difference between the development, staging, and production flavors in
   practical terms?

   **Context**: The codebase uses three different flavors for builds.

4. **Question**: Do I need to set up all three flavors on my local development environment to
   contribute to the project?

   **Context**: The documentation mentions different ways to run each flavor.

## Project Structure

5. **Question**: Where should I add new files when implementing a feature? I notice there are
   different folders like "features", "utils", etc.

   **Context**: The project follows a specific folder structure that might not be immediately
   obvious.

6. **Question**: How does localization work in the app? I see ARB files but I'm not sure how to add
   new translated strings.

   **Context**: The app supports multiple languages using Flutter's localization system.

## Development Workflow

7. **Question**: How do I run tests to make sure my changes don't break existing functionality?

   **Context**: The project has various test types (unit, widget, integration) with different
   commands.

8. **Question**: The pre-commit hook prevents me from committing code with debugPrint. How can I
   temporarily bypass this check when debugging?

   **Context**: Sometimes during development, quick logging is needed before finalizing code.

## Specific Code Questions

9. **Question**: What's the difference between AppLogger.d(), AppLogger.i(), AppLogger.e(), etc.?

   **Context**: The AppLogger utility has multiple logging methods.

10. **Question**: When I use AppLogger.e(), what should I include as the error and stackTrace
    parameters?

    **Context**: The error logging methods take additional parameters beyond the message.

## PWA-related Questions

11. **Question**: How can I test the offline functionality of the PWA locally?

    **Context**: The documentation mentions that the app works offline after installation.

12. **Question**: What's the easiest way to demonstrate the PWA installation feature to other team
    members?

    **Context**: There are instructions for creating demo videos, but they might seem complex.