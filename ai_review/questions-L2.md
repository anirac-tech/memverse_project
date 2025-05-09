# Level 2 Questions and Concerns

These are more advanced questions and concerns about the Memverse codebase that would typically
require input from a senior developer.

## Architecture and Technical Decisions

1. **Question**: What was the rationale behind implementing custom lint rules versus simply relying
   on the pre-commit hooks for enforcing logging standards?

   **Context**: The project uses both approaches to prevent prohibited logging methods, which could
   be seen as redundant.

2. **Question**: How was the decision made between the current flavor setup versus using
   environment-specific .env files with --dart-define-from-file?

   **Context**: There are multiple approaches to handling environment configuration in Flutter.

3. **Question**: The dependency conflicts between the custom lint package and the main project make
   integration challenging. Would a different approach to static analysis be more sustainable?

   **Context**: The analyzer and dart_style version conflicts between packages create friction
   during development.

## Performance and Scalability

4. **Question**: What's the strategy for managing PWA caching as the app grows, particularly for
   user-generated content and Bible verse data?

   **Context**: The PWA documentation mentions different caching strategies but doesn't address
   scaling concerns.

5. **Question**: As the codebase grows, what metrics should we track to ensure our logging
   implementation doesn't impact performance in debug builds?

   **Context**: Extensive logging can impact app performance, especially on lower-end devices.

6. **Question**: How do we plan to handle versioning of the offline data schema as the app evolves?

   **Context**: The PWA supports offline functionality with local data storage.

## Security and Compliance

7. **Question**: What security measures protect user data stored in the PWA's IndexedDB when the app
   is installed on shared devices?

   **Context**: The PWA technical documentation mentions encryption for sensitive information but
   lacks specifics.

8. **Question**: Are there compliance considerations (GDPR, CCPA) that should be addressed in our
   error logging implementation, especially regarding personally identifiable information?

   **Context**: Error logs might inadvertently contain user data.

## CI/CD and Development Experience

9. **Question**: The localization file formatting issues in the CI pipeline suggest deeper problems
   with our code generation approach. Should we consider alternatives to the current localization
   setup?

   **Context**: Generated files causing CI failures creates ongoing maintenance overhead.

10. **Question**: How do we ensure the custom lint rules remain compatible with future Dart SDK
    versions?

    **Context**: The analyzer API can change between versions, potentially breaking our custom
    rules.

## Testing Strategy

11. **Question**: The pre-commit hook excludes golden tests from blocking commits. How do we ensure
    visual regression issues are caught early in the development process?

    **Context**: The README mentions golden tests being handled separately from other tests.

12. **Question**: What's our strategy for testing app behavior across different versions of the same
    browser for PWA compatibility?

    **Context**: PWA features can have varying support levels across browser versions.

## Future Development

13. **Question**: How should we approach extending AppLogger to support remote logging/crash
    reporting services like Firebase Crashlytics or Sentry?

    **Context**: Production apps often need remote logging capabilities beyond local debug logs.

14. **Question**: If we need to support multiple PWA instances (e.g., a separate staging PWA), how
    should we structure the service worker to prevent cache collisions?

    **Context**: The technical documentation mentions that each preview deployment has isolated
    storage.