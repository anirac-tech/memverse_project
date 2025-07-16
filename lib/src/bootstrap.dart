import 'dart:async';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/utils/app_logger.dart';

/// Class to hold bootstrap configuration
class BootstrapConfig {
  /// Constructor
  const BootstrapConfig({required this.clientId});

  /// The client ID used for authentication
  final String clientId;
}

/// Error widget shown when required configuration is missing
class ConfigurationErrorWidget extends StatelessWidget {
  /// Creates a new ConfigurationErrorWidget
  const ConfigurationErrorWidget({required this.error, super.key});

  /// The error message to display
  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
}

/// Provider for bootstrap configuration
final bootstrapProvider = Provider<BootstrapConfig>((ref) {
  // Get the CLIENT_ID from dart-define, using debug fallback if needed
  var clientId = const String.fromEnvironment('CLIENT_ID');
  if (clientId.isEmpty && kDebugMode) {
    clientId = 'debug';
  }
  if (clientId.isEmpty) {
    throw Exception(
      'CLIENT_ID environment variable is not defined. '
      'Please run with --dart-define=CLIENT_ID=your_client_id',
    );
  }
  return BootstrapConfig(clientId: clientId);
});

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  try {
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

    // Wrap the app with BetterFeedback and ProviderScope
    runApp(ProviderScope(child: BetterFeedback(child: await builder())));
  } catch (e, stackTrace) {
    AppLogger.e('Error during bootstrap: $e', e, stackTrace);
    runApp(ConfigurationErrorWidget(error: 'Error during app initialization: $e'));
  }
}
