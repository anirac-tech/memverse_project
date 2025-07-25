# Memverse App Setup Guide

This document provides instructions for setting up environment variables for the Memverse app
development.

## Required Environment Variables

The app requires three environment variables for proper functionality:

- **`MEMVERSE_CLIENT_ID`** - Client ID for authentication with the Memverse API
- **`MEMVERSE_CLIENT_API_KEY`** - API key for bearer token authentication with the signup endpoint
- **`POSTHOG_MEMVERSE_API_KEY`** - PostHog API key for analytics and logging in development

## Setting Up Environment Variables

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
   export MEMVERSE_CLIENT_ID="your_client_id_here"
   export MEMVERSE_CLIENT_API_KEY="your_client_api_key_here"
   export POSTHOG_MEMVERSE_API_KEY="your_posthog_api_key_here"
   ```

3. Save the file and reload your configuration:
   ```bash
   source ~/.bashrc  # or ~/.bash_profile for Bash
   source ~/.zshrc   # for Zsh
   ```

4. Verify that the variables are set correctly:
   ```bash
   echo $MEMVERSE_CLIENT_ID
   echo $MEMVERSE_CLIENT_API_KEY
   echo $POSTHOG_MEMVERSE_API_KEY
   ```

### For Windows Command Prompt

1. Open Command Prompt as Administrator

2. Set the environment variables:
   ```cmd
   setx MEMVERSE_CLIENT_ID "your_client_id_here"
   setx MEMVERSE_CLIENT_API_KEY "your_client_api_key_here"
   setx POSTHOG_MEMVERSE_API_KEY "your_posthog_api_key_here"
   ```

3. Close and reopen Command Prompt

4. Verify that the variables are set correctly:
   ```cmd
   echo %MEMVERSE_CLIENT_ID%
   echo %MEMVERSE_CLIENT_API_KEY%
   echo %POSTHOG_MEMVERSE_API_KEY%
   ```

### For Windows PowerShell

1. Open PowerShell as Administrator

2. Set the environment variables:
   ```powershell
   [Environment]::SetEnvironmentVariable("MEMVERSE_CLIENT_ID", "your_client_id_here", "User")
   [Environment]::SetEnvironmentVariable("MEMVERSE_CLIENT_API_KEY", "your_client_api_key_here", "User")
   [Environment]::SetEnvironmentVariable("POSTHOG_MEMVERSE_API_KEY", "your_posthog_api_key_here", "User")
   ```

3. Close and reopen PowerShell

4. Verify that the variables are set correctly:
   ```powershell
   echo $env:MEMVERSE_CLIENT_ID
   echo $env:MEMVERSE_CLIENT_API_KEY
   echo $env:POSTHOG_MEMVERSE_API_KEY
   ```

## Running the App with Environment Variables

Once you've set up your environment variables, you can run the app using:

```bash
flutter run --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY --flavor production --target lib/main_production.dart --dart-define=MEMVERSE_CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY
```

This command will pass your MEMVERSE_CLIENT_ID, MEMVERSE_CLIENT_API_KEY, and
POSTHOG_MEMVERSE_API_KEY values to the app as the CLIENT_ID, CLIENT_API_KEY, and
POSTHOG_MEMVERSE_API_KEY parameters respectively.

## Troubleshooting

If the app is not picking up your CLIENT_ID or POSTHOG_MEMVERSE_API_KEY:

1. Ensure the environment variables are correctly set in your current terminal session
2. Try printing the values directly before running the app: `echo $MEMVERSE_CLIENT_ID` and
   `echo $POSTHOG_MEMVERSE_API_KEY`
3. Check if there are any spaces or special characters in your client ID or API key that might need
   escaping
4. Restart your terminal or IDE
