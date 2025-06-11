# Setting Up Jira Integration for Memverse Feedback

This document provides instructions for integrating the Memverse app's feedback feature with Jira,
allowing users to submit feedback directly to your Jira instance.

## NPS SaaS FAQ Section

### PostHog Open Source Pricing Model

PostHog offers one of the most generous free tiers available for NPS and analytics tracking:

**Free Tier (Forever):**

- **1M events per month** - All user interactions, NPS submissions, analytics events
- **250 survey responses per month** - Perfect for NPS tracking
- **5K session recordings per month** - User behavior analysis
- **Unlimited team members** - No restrictions on team size
- **1-year data retention** - Historical analysis
- **Self-hosting option** - Complete data ownership and privacy

**Key Benefits for NPS Tracking:**

- 90%+ of companies use PostHog for free (according to their own data)
- No credit card required for free tier
- EU-hosted and GDPR compliant
- Open source with self-hosting options
- Usage-based pricing after free tier (starts at $0.20 per survey response beyond 250/month)

**PostHog Official Pricing:** [https://posthog.com/pricing](https://posthog.com/pricing)

### Flutter NPS Tracking Solutions Comparison

#### Option 1: NPS Plugin + PostHog (Recommended - $0 Cost)

**Setup:**

```yaml
dependencies:
  nps_plugin: ^1.0.0
  posthog_flutter: ^4.0.1
```

**Implementation:**

```dart
// Trigger NPS survey
final (:nps, :message, :phone) = await npsStart(
  context,
  npsTitle: 'How likely are you to recommend our app?',
  showInputPhone: false,
);

// Track to PostHog
await Posthog().capture(
  eventName: 'nps_submitted',
  properties: {
    'nps_score': nps,
    'feedback_message': message,
    'user_id': currentUserId,
    'app_version': appVersion,
  },
);
```

**Tracking Method:**

- Use PostHog's event tracking to capture NPS responses
- Custom dashboards in PostHog for NPS analytics
- Real-time NPS score calculations
- Segmentation by user properties

**Cost:** Free for up to 1M events/month (covers ~4000 NPS responses)

#### Option 2: Wiredash (Freemium with NPS)

**Features:**

- Built-in NPS surveys (Promoter Score)
- Screenshot feedback collection
- Real-time analytics dashboard
- Free up to 100,000 monthly active devices

**Setup:**

```yaml
dependencies:
  wiredash: ^2.5.0
```

**Implementation:**

```dart
// Launch NPS survey
Wiredash.of(context).showPromoterSurvey(force: true);

// Access analytics via Wiredash Console
```

**Cost:**

- Free: Up to 100K monthly active devices
- Paid: Contact for enterprise pricing

#### Option 3: Custom Solution + Firebase/Supabase (Free)

**Architecture:**

```dart
// Custom NPS widget + free backend
class CustomNPSWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Rate us 0-10'),
        Row(
          children: List.generate(11, (index) => 
            IconButton(
              icon: Icon(index <= 5 ? Icons.sentiment_very_dissatisfied : 
                        index <= 8 ? Icons.sentiment_neutral :
                        Icons.sentiment_very_satisfied),
              onPressed: () => submitNPS(index),
            )
          ),
        ),
      ],
    );
  }
}
```

**Backend Options:**

- Firebase Firestore (free quota: 50K reads, 20K writes/day)
- Supabase (free quota: 50MB database, 500MB bandwidth)
- Self-hosted PostgreSQL/MongoDB

#### Option 4: Emoji-Based NPS Alternative

**Simple 5-Star Emoji Rating:**

```dart
class EmojiNPSWidget extends StatelessWidget {
  final List<String> emojis = ['😡', '😞', '😐', '😊', '😍'];
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: emojis.asMap().entries.map((entry) => 
        GestureDetector(
          onTap: () => submitEmojiRating(entry.key + 1),
          child: Text(entry.value, style: TextStyle(fontSize: 40)),
        )
      ).toList(),
    );
  }
}
```

### Wiredash Alternatives Analysis

#### 1. **Doorbell.io** - Still Active (2024)

- **Status:** Active and maintained
- **Pricing:** $49/month for basic plan
- **Features:** Feedback widget, email notifications, Slack integration
- **Flutter Support:** Web widget integration only

#### 2. **Instabug**

- **Pricing:** Free tier (up to 1 app, 1 team member)
- **Features:** Crash reporting, bug reporting, surveys
- **Flutter Support:** Native SDK available
- **Best For:** Bug reporting with feedback

#### 3. **UserVoice**

- **Pricing:** $499/month minimum
- **Features:** Advanced feedback management, roadmap sharing
- **Best For:** Enterprise feedback management

#### 4. **Helpshift**

- **Pricing:** Contact for pricing
- **Features:** In-app messaging, knowledge base
- **Best For:** Customer support integration

#### 5. **Appcues** (Limited NPS)

- **Pricing:** $249/month
- **Features:** User onboarding with basic NPS
- **Best For:** User onboarding flows

### Cost-Effective Recommendations by Use Case

#### Startup/Small App (< 10K users)

1. **NPS Plugin + PostHog** (Free)
2. **Wiredash** (Free tier)
3. **Custom Solution + Firebase** (Free)

#### Growing App (10K-100K users)

1. **PostHog** ($0-50/month depending on usage)
2. **Wiredash** (Free for 100K devices)
3. **Instabug** (Free + paid tiers)

#### Enterprise App (100K+ users)

1. **PostHog Self-hosted** (Infrastructure costs only)
2. **Wiredash Enterprise** (Contact pricing)
3. **Custom solution with dedicated backend**

### Implementation Timeline

**Week 1:** PostHog + NPS Plugin Integration

- Set up PostHog account and Flutter SDK
- Implement nps_plugin
- Create basic NPS event tracking

**Week 2:** Analytics Dashboard Setup

- Configure PostHog dashboards
- Set up NPS score calculations
- Implement user segmentation

**Week 3:** Advanced Features

- Add feedback categorization
- Implement follow-up surveys
- Set up automated alerts for low NPS scores

### Self-Hosted Open Source Alternative

For complete cost control and data ownership:

**PostHog Self-Hosted:**

- Docker/Kubernetes deployment
- PostgreSQL + ClickHouse backend
- Full feature set available
- Only infrastructure costs (AWS/GCP/Azure)

**Estimated monthly costs:**

- Small deployment: $50-100/month
- Medium deployment: $200-500/month
- Large deployment: $1000+/month

This provides unlimited events, users, and complete data ownership.

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

import 'dart:convert';
import 'dart:log';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Jira credentials - store these securely in production
const String jiraBaseUrl = 'https://your-instance.atlassian.net';
const String jiraProject = 'MEM'; // Your project key
const String jiraEmail = 'your-email@example.com'; // Jira account email
const String jiraApiToken = 'your-api-token'; // From Step 1

/// Handles the feedback submission by sending it directly to Jira
Future<void> handleFeedbackSubmission(BuildContext context, UserFeedback feedback) async {
log('Submitting feedback directly to Jira');

// declare file here so it's in scope for both try and catch
File? file;

try {
// 1. Save screenshot to temporary file
final dir = await getTemporaryDirectory();
final timestamp = DateTime.now().millisecondsSinceEpoch;
file = File('${dir.path}/memverse_feedback_$timestamp.png');
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
    if (file != null && file.existsSync()) {
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

## Step 3: Update the App Configuration

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
