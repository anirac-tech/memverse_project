# Memverse App Setup Guide

This document provides instructions for setting up environment variables for the Memverse app
development.

## Setting up CLIENT_ID Environment Variable

The app requires a CLIENT_ID for authentication with the Memverse API. You can set this up as an
environment variable to avoid hardcoding values in your code.

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

2. Add the following line to the file:
   ```bash
   export MEMVERSE_CLIENT_ID="your_client_id_here"
   ```

3. Save the file and reload your configuration:
   ```bash
   source ~/.bashrc  # or ~/.bash_profile for Bash
   source ~/.zshrc   # for Zsh
   ```

4. Verify that the variable is set correctly:
   ```bash
   echo $MEMVERSE_CLIENT_ID
   ```

### For Windows Command Prompt

1. Open Command Prompt as Administrator

2. Set the environment variable:
   ```cmd
   setx MEMVERSE_CLIENT_ID "your_client_id_here"
   ```

3. Close and reopen Command Prompt

4. Verify that the variable is set correctly:
   ```cmd
   echo %MEMVERSE_CLIENT_ID%
   ```

### For Windows PowerShell

1. Open PowerShell as Administrator

2. Set the environment variable:
   ```powershell
   [Environment]::SetEnvironmentVariable("MEMVERSE_CLIENT_ID", "your_client_id_here", "User")
   ```

3. Close and reopen PowerShell

4. Verify that the variable is set correctly:
   ```powershell
   echo $env:MEMVERSE_CLIENT_ID
   ```

## Running the App with Environment Variables

Once you've set up your environment variable, you can run the app using:

```bash
flutter run --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID --flavor development --target lib/main_development.dart
```

This command will pass your MEMVERSE_CLIENT_ID value to the app as the CLIENT_ID parameter.

## Troubleshooting

If the app is not picking up your CLIENT_ID:

1. Ensure the environment variable is correctly set in your current terminal session
2. Try printing the value directly before running the app: `echo $MEMVERSE_CLIENT_ID`
3. Check if there are any spaces or special characters in your client ID that might need escaping
4. Restart your terminal or IDE