# Setting Up Jira Integration for Memverse Feedback

This document provides instructions for integrating the Memverse app's feedback feature with Jira,
allowing users to submit feedback directly to your Jira instance.

## Option 1: Using Jira's Email Integration

The simplest approach is to configure your device's default email client to send feedback to Jira's
email handler.

### Step 1: Configure Email Handler in Jira

1. **Log in to Jira** as an administrator
2. Navigate to **Administration** > **System** > **Mail** > **Incoming Mail**
3. Click **Add mail handler**
4. Select **Create or Comment on Issues**
5. Fill in the configuration:
    - **Name**: Memverse Feedback Handler
    - **Description**: Processes feedback from the Memverse app
    - **Mail Server Configuration**: Select your configured mail server
    - **Handler Type**: Create issue or add comment from email
    - **Issue Type**: Select "Bug" or create a custom issue type like "User Feedback"
    - **Project**: Your project key (e.g., MEM for Memverse)
    - **Workflow**: Default workflow or custom workflow
    - **Create Users**: Choose whether to create Jira users for email senders
    - **Default Reporter**: Select a default reporter for all feedback
    - **Catch Email Address**: Create a dedicated email (e.g., memverse-feedback@yourdomain.com)
    - **Bulk**: Uncheck "Bulk" to process all messages individually

6. In **Message Handler Options**:
    - **Subject Format**: Set to include a prefix for identification (e.g.,
      `[MEM-Feedback] ${subject}`)
    - **Configure field mapping** to extract data from emails

7. Click **Add** to save the configuration

### Step 2: Configure Default Sharing to Use the Jira Email

When users trigger the feedback share dialog, they need to select the email option and use the Jira
handler email address. You can encourage this by:

1. Adding the Jira email address (e.g., memverse-feedback@yourdomain.com) to the subject line so
   users can easily copy it
2. Adding instructions in the feedback text template
3. Pre-configuring the email address in app settings (if applicable)

## Option 2: Direct Jira API Integration

For a more seamless experience, you can modify the app to post directly to Jira's REST API instead
of using the share dialog.

### Step 1: Set Up a Jira API Token

1. Log in to your Jira instance
2. Go to **Account Settings** > **Security** > **API Tokens**
3. Create a new API token labeled "Memverse Feedback"
4. Copy the token value (you won't be able to see it again)

### Step 2: Modify the Feedback Handler Code

Replace the existing feedback handler with Jira API integration:

```dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Jira credentials - store these securely in production
const String jiraBaseUrl = 'https://your-instance.atlassian.net';
const String jiraProject = 'MEM'; // Your project key
const String jiraEmail = 'your-email@example.com'; // Jira account email
const String jiraApiToken = 'your-api-token'; // From Step 1

/// Handles the feedback submission by sending it directly to Jira
Future<void> handleFeedbackSubmission(BuildContext context, UserFeedback feedback) async {
  log('Submitting feedback directly to Jira');

  try {
    // 1. Save screenshot to temporary file
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime
        .now()
        .millisecondsSinceEpoch;
    final file = File('${dir.path}/memverse_feedback_$timestamp.png');
    await file.writeAsBytes(feedback.screenshot);
    log('Screenshot saved to: ${file.path}');

    // 2. Create a Jira issue
    final issueResponse = await _createJiraIssue(feedback.text);
    final issueKey = issueResponse['key'];
    log('Created Jira issue: $issueKey');

    // 3. Attach the screenshot to the issue
    await _attachScreenshotToJira(issueKey, file);
    log('Attached screenshot to $issueKey');

    // 4. Notify the user
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted to Jira: $issueKey')),
      );
    }
  } catch (e, stack) {
    log('Error submitting to Jira: $e', stackTrace: stack);

    // Fall back to the share dialog
    if (File(file.path).existsSync()) {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: feedback.text,
        subject: 'Memverse App Feedback',
      );
    } else {
      await Share.share(
        feedback.text,
        subject: 'Memverse App Feedback',
      );
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Direct Jira submission failed, shared instead')),
      );
    }
  }
}

/// Creates a new Jira issue with the feedback text
Future<Map<String, dynamic>> _createJiraIssue(String feedbackText) async {
  final auth = base64Encode(utf8.encode('$jiraEmail:$jiraApiToken'));
  final response = await http.post(
    Uri.parse('$jiraBaseUrl/rest/api/2/issue'),
    headers: {
      'Authorization': 'Basic $auth',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'fields': {
        'project': {
          'key': jiraProject,
        },
        'summary': 'User Feedback from Memverse App',
        'description': feedbackText,
        'issuetype': {
          'name': 'Bug', // Or 'Feedback' if you created a custom type
        },
      },
    }),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to create Jira issue: ${response.statusCode} - ${response.body}');
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}

/// Attaches the screenshot to an existing Jira issue
Future<void> _attachScreenshotToJira(String issueKey, File screenshot) async {
  final auth = base64Encode(utf8.encode('$jiraEmail:$jiraApiToken'));

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$jiraBaseUrl/rest/api/2/issue/$issueKey/attachments'),
  );

  request.headers.addAll({
    'Authorization': 'Basic $auth',
    'X-Atlassian-Token': 'no-check',
  });

  request.files.add(await http.MultipartFile.fromPath(
    'file',
    screenshot.path,
    filename: 'screenshot.png',
  ));

  final response = await request.send();

  if (response.statusCode != 200) {
    throw Exception('Failed to attach screenshot: ${response.statusCode}');
  }
}
```

### Step 3: Update the App Configuration

1. Modify the feedback button to use the new Jira integration:

```dart
IconButton
(
icon: const Icon(Icons.feedback_outlined),
tooltip: 'Send Feedback to Jira',
onPressed: () {
log('Feedback button pressed');
BetterFeedback.of(context).show((feedback) async {
await handleFeedbackSubmission(context, feedback);
});
},
)
,
```

2. Add the required HTTP dependency to `pubspec.yaml` if not already present:

```yaml
dependencies:
  http: ^1.1.0  # Should already be in your dependencies
```

## Security Considerations

1. **API Token Storage**: In a production app, store the Jira API token securely:
    - Use encrypted shared preferences
    - Consider Flutter Secure Storage
    - Possibly use a backend proxy service

2. **User Authentication**: Consider whether to associate feedback with authenticated users

3. **Rate Limiting**: Implement rate limiting to prevent abuse

4. **Permissions**: Ensure the Jira account used has appropriate permissions to:
    - Create issues in the target project
    - Upload attachments
    - Set required fields

## Testing the Integration

1. Test with a staging Jira project first
2. Verify all required fields are completed properly
3. Check that attachments are properly associated with the created issues
4. Test the fallback mechanism when offline or when errors occur

## Troubleshooting Common Issues

1. **Authentication Errors**:
    - Verify API token and email are correct
    - Check that the token has not expired
    - Ensure token has proper permissions

2. **Field Validation Errors**:
    - Check for required fields in your Jira project configuration
    - Ensure issue type is valid for the project

3. **Attachment Failures**:
    - Verify file size limits
    - Check permission settings
    - Test file format compatibility