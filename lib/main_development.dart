// Import for web-specific functionality
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize analytics service
  final container = ProviderContainer();
  final analyticsService = container.read(analyticsServiceProvider);

  const apiKey = String.fromEnvironment('POSTHOG_MEMVERSE_API_KEY');
  if (apiKey.isNotEmpty) {
    // Web-specific JavaScript initialization
    if (kIsWeb) {
      try {
        js.context.callMethod('initPostHog', [apiKey]);
        AppLogger.i('PostHog JavaScript SDK initialized for web');
      } catch (e) {
        AppLogger.e('Failed to initialize PostHog JavaScript SDK: $e');
      }
    }

    await analyticsService.init(apiKey: apiKey);
  } else {
    AppLogger.e('Error: POSTHOG_MEMVERSE_API_KEY environment variable is not set');
  }

  bootstrap(() => ProviderScope(parent: container, child: const App()));
}
