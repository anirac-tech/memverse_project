# Memverse App Test Setup Guide

This document provides instructions for setting up environment variables needed for testing the
Memverse app, particularly for live API integration tests.

## Setting up Test Account Environment Variables

The integration tests require valid Memverse credentials to run tests against the live API. To keep
these credentials secure, you should set them as environment variables.

### For Bash/Zsh (macOS/Linux)

1. Edit your shell configuration file:

   For Bash:
   ```bash
   nano ~/.bashrc  # or ~/.bash_profile
   ```

   For Zsh:
   ```bash
   nano ~/.zshrc
   ```

2. Add the following lines to the file:
   ```bash
   export MEMVERSE_USERNAME="your_test_account_username"
   export MEMVERSE_PASSWORD="your_test_account_password"
   export MEMVERSE_CLIENT_ID="your_client_id"
   ```

3. Save the file and reload your configuration:
   ```bash
   source ~/.bashrc  # or ~/.bash_profile for Bash
   source ~/.zshrc   # for Zsh
   ```

4. Verify that the variables are set correctly:
   ```bash
   echo $MEMVERSE_USERNAME
   echo $MEMVERSE_PASSWORD
   echo $MEMVERSE_CLIENT_ID
   ```

### For Windows Command Prompt

1. Open Command Prompt as Administrator

2. Set the environment variables:
   ```cmd
   setx MEMVERSE_USERNAME "your_test_account_username"
   setx MEMVERSE_PASSWORD "your_test_account_password"
   setx MEMVERSE_CLIENT_ID "your_client_id"
   ```

3. Close and reopen Command Prompt

4. Verify that the variables are set correctly:
   ```cmd
   echo %MEMVERSE_USERNAME%
   echo %MEMVERSE_PASSWORD%
   echo %MEMVERSE_CLIENT_ID%
   ```

### For Windows PowerShell

1. Open PowerShell as Administrator

2. Set the environment variables:
   ```powershell
   [Environment]::SetEnvironmentVariable("MEMVERSE_USERNAME", "your_test_account_username", "User")
   [Environment]::SetEnvironmentVariable("MEMVERSE_PASSWORD", "your_test_account_password", "User")
   [Environment]::SetEnvironmentVariable("MEMVERSE_CLIENT_ID", "your_client_id", "User")
   ```

3. Close and reopen PowerShell

4. Verify that the variables are set correctly:
   ```powershell
   echo $env:MEMVERSE_USERNAME
   echo $env:MEMVERSE_PASSWORD
   echo $env:MEMVERSE_CLIENT_ID
   ```

## Running Live Integration Tests

Once you've set up your environment variables, you can run the live integration tests using:

```bash
flutter test integration_test/live_login_test.dart --flavor development --dart-define=USERNAME=$MEMVERSE_USERNAME --dart-define=PASSWORD=$MEMVERSE_PASSWORD --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID
```

Or use the provided script:

```bash
dart run scripts:test_live_login
```

This command will:

1. Run the integration test using your credentials
2. Use the development flavor of the app
3. Pass the environment variables to the test

## Android Testing

To run the tests on Android and capture screenshots:

```bash
flutter test integration_test/live_login_test.dart -d <android-device-id> --flavor development --dart-define=USERNAME=$MEMVERSE_USERNAME --dart-define=PASSWORD=$MEMVERSE_PASSWORD --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID
```

Screenshots will be saved in the `/data/user/0/<package-name>/cache/` directory on your device.

## Security Considerations

- Never commit your actual credentials to version control
- Consider using a dedicated test account with limited permissions
- Regularly rotate the password for your test account
- In CI/CD pipelines, use secure environment variables