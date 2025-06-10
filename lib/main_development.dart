// Import for web-specific functionality
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/common/services/analytics_bootstrap.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web-specific JavaScript initialization for PostHog
  if (kIsWeb) {
    const apiKey = String.fromEnvironment('POSTHOG_MEMVERSE_API_KEY');
    if (apiKey.isNotEmpty) {
      try {
        js.context.callMethod('initPostHog', [apiKey]);
        AppLogger.i('PostHog JavaScript SDK initialized for web');
      } catch (e) {
        AppLogger.e('Failed to initialize PostHog JavaScript SDK: $e');
      }
    }
  }

  // Initialize analytics with bootstrap
  await AnalyticsBootstrap.initialize(
    entryPoint: AnalyticsEntryPoint.mainDevelopment,
    flavor: 'development',
    memverseApiUrl: const String.fromEnvironment(
      'MEMVERSE_API_URL',
      defaultValue: 'https://api-dev.memverse.com',
    ),
  );

  bootstrap(() => const ProviderScope(child: App()));
}
