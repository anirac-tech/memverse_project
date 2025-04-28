# Setting Up Bugsee for Android

This document provides instructions for integrating Bugsee into the Memverse Android app to enhance
feedback and bug reporting with advanced SDK capabilities.

## What is Bugsee?

[Bugsee](https://www.bugsee.com/) is an advanced bug reporting and user feedback SDK that provides:

- Video recordings of user sessions
- Network request logs
- Console logs and crash reports
- User interactions and screen captures
- System metrics and device information

## Step 1: Account Setup

1. Visit [Bugsee.com](https://www.bugsee.com/) and sign up for an account
2. Create a new application in the Bugsee dashboard:
    - Go to "Applications" > "Add new application"
    - Select "Android" as the platform
    - Name your app "Memverse Android"
    - Configure other settings as needed
3. On completion, you'll receive an **App Token** - save this for the integration steps

## Step 2: Install the Bugsee SDK

1. Add the Bugsee repository to your project's `build.gradle` file:

```groovy
allprojects {
    repositories {
        maven { url 'https://maven.bugsee.com' }
        // Other repositories...
    }
}
```

2. Add the Bugsee SDK dependency in your app's `build.gradle`:

```groovy
dependencies {
    // Other dependencies...
    implementation 'com.bugsee:bugsee-android:X.Y.Z' // Check for the latest version
}
```

3. Sync your project to download the dependency

## Step 3: Configure Android Permissions

Add these permissions to your `AndroidManifest.xml`:

```xml
<!-- Required permissions -->
<uses-permission android:name="android.permission.INTERNET" /><uses-permission
android:name="android.permission.ACCESS_NETWORK_STATE" />

    <!-- Optional but recommended permissions -->
<uses-permission android:name="android.permission.READ_LOGS" tools:ignore="ProtectedPermissions" />

    <!-- For video recording -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" /><uses-permission
android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

## Step 4: Initialize Bugsee

1. Create a `bugsee_config.xml` file in your `res/values` folder:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="bugsee_token">YOUR_APP_TOKEN</string>
</resources>
```

2. Initialize Bugsee in your Application class:

```kotlin
// In your Application class
override fun onCreate() {
    super.onCreate()

    // Initialize Bugsee
    val options = BugseeOptions.Builder()
        .maxRecordingTime(60) // Max recording time in seconds
        .videoQuality(VideoQuality.HIGH)
        .screenshotQuality(ScreenshotQuality.HIGH)
        .captureLogs(true)
        .captureNetworkRequests(true)
        .build()

    Bugsee.launch(this, R.string.bugsee_token, options)
}
```

Or in Java:

```java

@Override
public void onCreate() {
    super.onCreate();

    // Initialize Bugsee
    BugseeOptions options = new BugseeOptions.Builder()
            .maxRecordingTime(60) // Max recording time in seconds
            .videoQuality(VideoQuality.HIGH)
            .screenshotQuality(ScreenshotQuality.HIGH)
            .captureLogs(true)
            .captureNetworkRequests(true)
            .build();

    Bugsee.launch(this, R.string.bugsee_token, options);
}
```

## Step 5: Implement the Feedback Button

Replace or augment the existing feedback button with Bugsee's feedback launcher:

```kotlin
// Replace the existing feedback button implementation
IconButton(
    icon = Icon(Icons.Default.BugReport),
    tooltip = "Report Bug or Send Feedback",
    onClick = {
        Bugsee.showReportDialog()
    }
)
```

Or if using Java:

```java
IconButton(
        icon =const Icon(Icons.Default.BugReport),

tooltip ="Report Bug or Send Feedback",
onPressed =(){
        Bugsee.

showReportDialog();
    }
            );
```

## Step 6: Add Custom Data and Events

Enhance the bug reports with custom data relevant to the app:

```kotlin
// Add user information
Bugsee.setEmail(userEmail)
Bugsee.setUserIdentifier(userId)
Bugsee.setAttribute("subscription_status", subscriptionStatus)

// Log custom events
Bugsee.event("verse_memorized", mapOf("reference" to "John 3:16", "time_taken" to 120))

// Add breadcrumbs for easier debugging
Bugsee.trace("User navigated to memory test screen")
```

## Step 7: Handle Sensitive Data

Configure privacy settings to protect user data:

```kotlin
// Mask sensitive views
Bugsee.registerSensitiveViewById(R.id.password_field)

// Ignore specific network requests
val filters = Bugsee.networkFilter()
filters.add("*auth/token*", NetworkFilter.Type.URL)

// Add custom data redaction
Bugsee.addDataObfuscator { data, type ->
    if (type == ObfuscationType.NETWORK && data.contains("password")) {
        return data.replace(Regex("password=.*?(&|$)"), "password=***$1")
    }
    return data
}
```

## Step 8: Testing the Integration

1. Build and launch your app
2. Test the bug reporting feature by:
    - Triggering the feedback button
    - Shaking the device (if shake-to-report is enabled)
    - Triggering a test crash: `Bugsee.testExceptionCrash()`
3. Verify reports appear in your Bugsee dashboard

## Step 9: Configure Jira Integration (Optional)

Connect Bugsee to your Jira instance:

1. In the Bugsee dashboard, go to "Integrations" > "Jira"
2. Configure the connection using your Jira API token and domain
3. Set up field mappings between Bugsee data and Jira fields

## Troubleshooting

### Common Issues

1. **High Battery Consumption**
    - Reduce video quality
    - Lower maximum recording time
    - Set `Bugsee.stop()` when the app goes to background

2. **Performance Problems**
    - Use `Bugsee.pause()` during performance-critical code sections
    - Lower capture resolution and recording quality

3. **App Size Concerns**
    - Consider using Bugsee in debug builds only
    - Use ProGuard/R8 with the provided Bugsee rules

### Debugging the Integration

Monitor your integration with debug logging:

```kotlin
Bugsee.setLogLevel(LogLevel.VERBOSE)
```

## Next Steps

- Configure crash alerting in the Bugsee dashboard
- Set up team members and notification rules
- Consider creating different Bugsee tokens for development, staging, and production environments

For more detailed information, visit
the [Bugsee Android Documentation](https://docs.bugsee.com/sdk/android/installation/).