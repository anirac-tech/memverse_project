// Import for web-specific functionality
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/utils/app_logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

bool hasPostHog = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const apiKey = String.fromEnvironment('POSTHOG_MEMVERSE_API_KEY');
  if (apiKey.isEmpty) {
    AppLogger.e('Error: POSTHOG_MEMVERSE_API_KEY environment variable is not set');
  } else {
    if (kDebugMode) {
      AppLogger.d('PostHog API Key: $apiKey');
    }

    // Web-specific initialization
    if (kIsWeb) {
      try {
        // Call the JavaScript initialization function
        js.context.callMethod('initPostHog', [apiKey]);
        AppLogger.i('PostHog JavaScript SDK initialized for web');
      } catch (e) {
        AppLogger.e('Failed to initialize PostHog JavaScript SDK: $e');
      }
    }

    final config = PostHogConfig(apiKey);
    config.host = 'https://us.i.posthog.com';
    config.debug = kDebugMode;
    config.captureApplicationLifecycleEvents = true;

    // Platform-specific configuration
    if (kIsWeb) {
      // Web-specific PostHog configuration
      config.sessionReplay = true; // Web supports session replay
      config.sessionReplayConfig.maskAllTexts = false;
      config.sessionReplayConfig.maskAllImages = false;

      AppLogger.i('PostHog configured for web with session replay enabled');
    } else {
      // Mobile-specific configuration
      config.sessionReplay = true;
      config.sessionReplayConfig.maskAllTexts = false;
      config.sessionReplayConfig.maskAllImages = false;

      AppLogger.i('PostHog configured for mobile with session replay');
    }

    // Setup PostHog with the given Context and Config
    await Posthog().setup(config);
    hasPostHog = true;

    if (kIsWeb) {
      AppLogger.i('PostHog web analytics fully initialized - JS + Flutter SDK ready');
    }
  }

  bootstrap(() => const App());
}
