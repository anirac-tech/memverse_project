# Setting Up Bugsee for iOS

This document provides instructions for integrating Bugsee into the Memverse iOS app to enhance
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
    - Select "iOS" as the platform
    - Name your app "Memverse iOS"
    - Configure other settings as needed
3. On completion, you'll receive an **App Token** - save this for the integration steps

## Step 2: Install the Bugsee SDK

### Using CocoaPods (Recommended)

1. If not already using CocoaPods, initialize it for your project:
   ```bash
   cd /path/to/memverse_project/ios
   pod init
   ```

2. Add Bugsee to your Podfile:
   ```ruby
   target 'Runner' do
     # Flutter Pods are added automatically
     
     # Add the Bugsee pod
     pod 'Bugsee'
   end
   ```

3. Install the pod:
   ```bash
   pod install
   ```

### Using Swift Package Manager

1. In Xcode, go to File > Swift Packages > Add Package Dependency
2. Enter the Bugsee SPM repository URL: `https://github.com/bugsee/bugsee-ios-swift-package`
3. Select the version you want to use (usually the latest stable)
4. Choose the target where you want to add Bugsee

## Step 3: Configure iOS Permissions

Add the necessary descriptions to your `Info.plist`:

```xml
<!-- For video recording -->
<key>NSCameraUsageDescription</key><string>Bugsee needs camera access to include a picture of you in
the bug report
</string>

    <!-- For microphone recording (optional) -->
<key>NSMicrophoneUsageDescription</key><string>Bugsee needs microphone access to include your voice
in the bug report
</string>

    <!-- For photo library access (optional) -->
<key>NSPhotoLibraryUsageDescription</key><string>Bugsee needs photo library access to include
screenshots in the bug report
</string>
```

## Step 4: Initialize Bugsee

### In Swift:

1. Import Bugsee in your AppDelegate:
   ```swift
   import Bugsee
   ```

2. Initialize in `application(_:didFinishLaunchingWithOptions:)`:
   ```swift
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       // Initialize Bugsee
       let options = BugseeOptions()
       options.maxRecordingTime = 60 // Max recording time in seconds
       options.videoQuality = .high
       options.screenshotQuality = .high
       options.captureLogs = true
       options.captureNetworkRequests = true
       
       Bugsee.launch(token: "YOUR_APP_TOKEN", options: options)
       
       // Normal Flutter setup
       GeneratedPluginRegistrant.register(with: self)
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
   }
   ```

### In Objective-C:

1. Import Bugsee in your AppDelegate:
   ```objc
   #import <Bugsee/Bugsee.h>
   ```

2. Initialize in `application:didFinishLaunchingWithOptions:`:
   ```objc
   - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       // Initialize Bugsee
       BugseeOptions *options = [[BugseeOptions alloc] init];
       options.maxRecordingTime = 60; // Max recording time in seconds
       options.videoQuality = BugseeVideoQualityHigh;
       options.screenshotQuality = BugseeScreenshotQualityHigh;
       options.captureLogs = YES;
       options.captureNetworkRequests = YES;
       
       [Bugsee launchWithToken:@"YOUR_APP_TOKEN" options:options];
       
       // Normal Flutter setup
       [GeneratedPluginRegistrant registerWithRegistry:self];
       return [super application:application didFinishLaunchingWithOptions:launchOptions];
   }
   ```

## Step 5: Create a Flutter Method Channel to Trigger Bugsee

Since Bugsee needs to be implemented in native code, create a method channel to communicate with it:

1. In your Flutter app, create a `BugseeService` class:

```dart
import 'package:flutter/services.dart';

class BugseeService {
  static const _methodChannel = MethodChannel('com.memverse/bugsee');

  // Show the bug report dialog
  Future<void> showReportDialog() async {
    try {
      await _methodChannel.invokeMethod('showBugseeReportDialog');
    } catch (e) {
      print('Error showing Bugsee report dialog: $e');
    }
  }

  // Log a custom event
  Future<void> logEvent(String name, Map<String, dynamic> attributes) async {
    try {
      await _methodChannel.invokeMethod('logBugseeEvent', {
        'name': name,
        'attributes': attributes,
      });
    } catch (e) {
      print('Error logging Bugsee event: $e');
    }
  }
}
```

2. Add the native implementation in iOS:

### In Swift:

```swift
// In AppDelegate.swift or a dedicated plugin file

// Register method channel
let channel = FlutterMethodChannel(name: "com.memverse/bugsee", binaryMessenger: flutterViewController as! FlutterBinaryMessenger)
channel.setMethodCallHandler { (call, result) in
  switch call.method {
  case "showBugseeReportDialog":
    Bugsee.showReport()
    result(nil)
  case "logBugseeEvent":
    if let args = call.arguments as? [String: Any],
       let name = args["name"] as? String,
       let attributes = args["attributes"] as? [String: Any] {
      Bugsee.event(name, attributes: attributes)
      result(nil)
    } else {
      result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
    }
  default:
    result(FlutterMethodNotImplemented)
  }
}
```

### In Objective-C:

```objc
// In AppDelegate.m or a dedicated plugin file

FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"com.memverse/bugsee" binaryMessenger:flutterViewController];
[channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
  if ([call.method isEqualToString:@"showBugseeReportDialog"]) {
    [Bugsee showReport];
    result(nil);
  } else if ([call.method isEqualToString:@"logBugseeEvent"]) {
    NSDictionary *args = call.arguments;
    NSString *name = args[@"name"];
    NSDictionary *attributes = args[@"attributes"];
    if (name && attributes) {
      [Bugsee eventWithName:name attributes:attributes];
      result(nil);
    } else {
      result([FlutterError errorWithCode:@"INVALID_ARGS" message:@"Invalid arguments" details:nil]);
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}];
```

## Step 6: Implement the Feedback Button in Flutter

Replace or augment the existing feedback button with Bugsee:

```dart
import 'package:memverse/src/services/bugsee_service.dart';

// In your widget
final bugseeService = BugseeService();

// Replace the existing feedback button
IconButton
(
icon: const Icon(Icons.bug_report),
tooltip: 'Report Bug or Send Feedback',
onPressed: () {
bugseeService.showReportDialog();
},
)
```

## Step 7: Add Custom Data and Events

Enhance the bug reports with custom data relevant to the app:

### In Flutter:

```dart
// Using the method channel
bugseeService.logEvent
('verse_memorized', {
'reference': 'John 3:16',
'time_taken': 120,
});
```

### In Native Swift:

```swift
// Add user information
Bugsee.setEmail("user@example.com")
Bugsee.setUserIdentifier("user123")
Bugsee.setAttribute("subscription_status", value: "premium")

// Add breadcrumbs for easier debugging
Bugsee.trace("User navigated to memory test screen")
```

## Step 8: Handle Sensitive Data

Configure privacy settings to protect user data:

### In Swift:

```swift
// Mask sensitive views
Bugsee.registerPrivateView(passwordField)

// Ignore specific network requests
let filter = Bugsee.networkFilter()
filter.add("*auth/token*", type: .url)

// Add custom data redaction
Bugsee.dataRedactionCallback = { (data, type) -> Any? in
  if type == .network, let stringData = data as? String, stringData.contains("password") {
    return stringData.replacingOccurrences(of: "password=\\S+(&|$)", with: "password=***$1", options: .regularExpression)
  }
  return data
}
```

## Step 9: Testing the Integration

1. Build and run your app on an iOS device
2. Test the bug reporting feature by:
    - Triggering the feedback button via your Flutter UI
    - Shaking the device (if shake-to-report is enabled)
    - Triggering a test crash: `Bugsee.testExceptionCrash()`
3. Verify reports appear in your Bugsee dashboard

## Step 10: Configure Jira Integration (Optional)

Connect Bugsee to your Jira instance:

1. In the Bugsee dashboard, go to "Integrations" > "Jira"
2. Configure the connection using your Jira API token and domain
3. Set up field mappings between Bugsee data and Jira fields

## Troubleshooting

### Common Issues

1. **Missing dSYM Files (For Symbolicated Crash Reports)**
    - Enable "Upload dSYM" in Xcode build settings
    - Or manually upload dSYMs to the Bugsee dashboard

2. **High Battery Consumption**
    - Reduce video quality
    - Lower maximum recording time
    - Set `Bugsee.stop()` when the app goes to background

3. **Performance Issues**
    - Use `Bugsee.pause()` during performance-critical code sections
    - Lower capture resolution and recording quality

4. **App Size Concerns**
    - Consider using Bugsee in debug builds only
    - Exclude architecture slices not needed for App Store submissions

### Debugging the Integration

Monitor your integration with debug logging:

```swift
Bugsee.setLogLevel(.verbose)
```

## Next Steps

- Configure crash alerting in the Bugsee dashboard
- Set up team members and notification rules
- Consider creating different Bugsee tokens for development, staging, and production environments

For more detailed information, visit
the [Bugsee iOS Documentation](https://docs.bugsee.com/sdk/ios/installation/).