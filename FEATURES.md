# Memverse App Features

This document lists the main features of the Memverse Flutter app and tracks their test coverage.

## Core Features

### 1. Authentication (`auth`)

- **Description:** Handles user sign-up, login, password reset, and session management.
- **Integration Tests:
  ** [login_page_test.dart](test/src/features/auth/presentation/login_page_test.dart)
- **Golden Tests:
  ** [login_page_golden_test.dart](test/src/features/auth/presentation/login_page_golden_test.dart)
- **Golden Images:**
    - [login_page.png](test/src/features/auth/presentation/goldens/login_page.png) (Generated on
      first test run)

### 2. Verse Management (`verse`)

- **Description:** Allows users to view, search, add, and manage memory verses. Includes features
  for memorization practice.
- **Integration Tests:
  ** [memverse_page_test.dart](test/src/features/verse/presentation/memverse_page_test.dart)
- **Golden Tests:
  ** [memverse_page_golden_test.dart](test/src/features/verse/presentation/memverse_page_golden_test.dart)
- **Golden Images:**
    - [memverse_page_portrait.png](test/src/features/verse/presentation/goldens/memverse_page_portrait.png) (
      Generated on first test run)
    - [memverse_page_landscape.png](test/src/features/verse/presentation/goldens/memverse_page_landscape.png) (
      Generated on first test run)

### 3. User Feedback (`feedback`)

- **Description:** Allows users to submit feedback directly from the app with screenshots and text.
  Integrates with device's native share system for email, messaging, and other sharing options.
- **Widget Tests:**
    * [memverse_page_test.dart](test/src/features/verse/presentation/memverse_page_test.dart) (tests
      for button presence)
- **Related Files:**
    * [feedback_handler.dart](lib/src/features/verse/presentation/feedback_handler.dart)
    * [feedback_setup_jira.md](feedback_setup_jira.md) (documentation for Jira integration)
- **Future Enhancements:**
    * Bugsee SDK integration for advanced bug reporting (
      see [todo_bugsee_android.md](todo_bugsee_android.md)
      and [todo_bugsee_ios.md](todo_bugsee_ios.md))

## Testing Instructions