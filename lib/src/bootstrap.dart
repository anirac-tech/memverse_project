import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Class to hold bootstrap configuration
class BootstrapConfig {
  /// Constructor
  const BootstrapConfig({required this.clientId});

  /// The client ID used for authentication
  final String clientId;
}

/// Provider for bootstrap configuration
final bootstrapProvider = Provider<BootstrapConfig>((ref) {
  // Always use the CLIENT_ID from dart-define
  const clientId = String.fromEnvironment('CLIENT_ID', defaultValue: 'defaultClientId');

  return BootstrapConfig(clientId: clientId);
});

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // Log the client ID that's being used (helps with debugging)
  const clientId = String.fromEnvironment('CLIENT_ID', defaultValue: 'defaultClientId');
  debugPrint('Using CLIENT_ID: $clientId');

  runApp(ProviderScope(overrides: [], child: await builder()));
}
