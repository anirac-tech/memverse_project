# Memverse.com Website Maestro Tests

This directory contains Maestro tests that interact with the memverse.com website. These tests are
designed to run on Android devices using Chrome browser.

## Test Components

The tests are structured in a modular way, with reusable components in the `components/` directory:

- `navigate_to_signup.yaml`: Opens the memverse.com website and navigates to the signup page
- `create_account.yaml`: Creates a new account with random credentials
- `login.yaml`: Logs in with provided credentials
- `delete_account.yaml`: Deletes an account (requires being logged in)

## Main Test Flows

- `create_login_delete_flow.yaml`: Complete end-to-end flow that creates an account, logs out, logs
  back in, and then deletes the account
- `delete_account_only.yaml`: Standalone flow for just deleting an existing account (requires
  name/password to be provided)

## Running Tests

### Full E2E Test

Run the complete test that creates and deletes an account:

```bash
./maestro/scripts/run_memverse_dot_com_tests.sh
```

### Deleting a Specific Account

To delete a specific account, run:

```bash
maestro test maestro/flows/memverse_dot_com/delete_account_only.yaml --env name=your_name password=your_password
```

## Requirements

- Android device with Chrome browser installed
- Maestro CLI installed on your development machine
- Device connected via ADB and authorized

## Notes

- These tests use randomly generated credentials to avoid conflicts
- Tests are designed to clean up after themselves (account deletion)
- No API usage - these are pure UI tests through Chrome browser
- Selectors are based on the text labels from the actual website UI
