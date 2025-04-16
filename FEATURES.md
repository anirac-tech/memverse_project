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

## Testing Instructions

### Running Tests Locally
