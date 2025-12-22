import 'dart:async';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/utils/app_logger.dart';

/// Error widget shown when required configuration is missing
class ConfigurationErrorWidget extends StatelessWidget {
  /// Creates a new ConfigurationErrorWidget
  const ConfigurationErrorWidget({required this.error, super.key});

  /// The error message to display
  final String error;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Configuration Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(error, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              const Text(
                'Please run the app with proper configuration:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'flutter run --dart-define=CLIENT_ID=your_client_id',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// with env variables in .zshrc or CI/CD
/// flutter run --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY --flavor production --target lib/main_production.dart --dart-define=MEMVERSE_CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Debug: Auto-fake a client ID for dev/test
    var clientId = const String.fromEnvironment('CLIENT_ID');
    if (clientId.isEmpty && kDebugMode) {
      clientId = 'debug';
    }
    if (clientId.isEmpty) {
      const errorMessage =
          'CLIENT_ID environment variable is not defined. '
          'This is required for authentication with the Memverse API.';
      AppLogger.e('ERROR: $errorMessage');
      runApp(
        const ConfigurationErrorWidget(
          error: 'Missing required CLIENT_ID configuration for authentication.',
        ),
      );
      return;
    }

    const clientSecret = String.fromEnvironment('MEMVERSE_CLIENT_API_KEY');
    if (clientSecret.isEmpty) {
      const errorMessage =
          'MEMVERSE_CLIENT_API_KEY environment variable is not dart-defined. '
          'This is required for authentication with the Memverse API.';
      AppLogger.e('ERROR: $errorMessage');
      runApp(
        const ConfigurationErrorWidget(
          error:
              'Missing required MEMVERSE_CLIENT_API_KEY environment variable.\n\n'
              'Please run with: --dart-define=MEMVERSE_CLIENT_API_KEY=your_api_key',
        ),
      );
      return;
    }

    final app = await builder();

    runApp(ProviderScope(child: BetterFeedback(child: app)));
  }, (error, stack) => AppLogger.e('Error during bootstrap: $error', error, stack));
}
