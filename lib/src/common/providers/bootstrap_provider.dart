import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Class to hold bootstrap values
class BootstrapValues {
  /// Constructor
  const BootstrapValues({required this.clientId});

  /// The client ID used for authentication
  final String clientId;
}

/// Provider for bootstrap values
final bootstrapProvider = Provider<BootstrapValues>((ref) {
  // Get the CLIENT_ID from dart-define
  const clientId = String.fromEnvironment('CLIENT_ID');

  // Validate that the CLIENT_ID is provided
  if (clientId.isEmpty) {
    throw Exception(
      'CLIENT_ID environment variable is not defined. '
      'Please run with --dart-define=CLIENT_ID=your_client_id',
    );
  }

  return const BootstrapValues(clientId: clientId);
});
