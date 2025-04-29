# Jira Ticket Phase Two Tasks

## Overview

This phase focuses on improving test coverage, adding user settings for feedback, and providing
setup instructions.

## Tasks

1. **Fix Code Coverage Ignores:**
    * Go through the codebase and remove unnecessary `// ignore` or `//ignore` comments used for
      test coverage.
    * Ensure corresponding tests are added or updated to cover the previously ignored lines.
    * Aim for the 100% coverage goal as defined in the project guidelines.

2. **Implement Settings Screen:**
    * Create a new feature screen for user settings.
    * Add an option (e.g., a Radio button group, Dropdown, or Toggle Switch) for the user to choose
      their preferred email feedback method:
        * **Jira Email:** Send feedback directly to a predefined Jira email address.
        * **Blank Email:** Open a blank email draft in the user's default email client.
    * Use Riverpod for state management of the selected setting.
    * Localize all user-facing strings in English and Spanish.

3. **Add Jira Email Setup Instructions:**
    * Include a section within the Settings screen or a separate help/documentation area accessible
      from Settings.
    * Provide clear, step-by-step instructions for users or administrators on how to configure the `Jira Email` integration if it requires specific setup (e.g., setting up an incoming mail handler in Jira).
    * *Example Steps (Adapt as needed)*:
        * Go to Jira Project Settings -> Email Requests.
        * Configure a custom email address (e.g., `feedback-memverse@yourdomain.atlassian.net`).
        * Ensure the request type and issue type are set correctly for incoming feedback.
        * Note the generated email address. This address needs to be configured within the app (
          potentially via environment variables or a configuration file).
4. **Patrol Tests:** *(Skipped for now: Addressing untested Patrol tests or writing new ones)*
    * Investigate and resolve issues with *existing* Patrol tests if they are currently failing.
    * Ensure all *existing* integration tests using Patrol pass reliably.

## Acceptance Criteria

* Code coverage ignores are significantly reduced or eliminated, backed by actual test coverage.
* A functional Settings screen exists allowing users to select between Jira email and blank email
  feedback.
* Clear instructions are available on how to set up the Jira email integration.
* All new code adheres to project guidelines (localization, formatting, Riverpod usage, testing
  principles).
* The `check_before_commit.sh` script passes.
