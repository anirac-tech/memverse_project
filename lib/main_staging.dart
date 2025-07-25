import 'package:flutter/foundation.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/constants/api_constants.dart';

void main() async {
  const clientId = String.fromEnvironment('CLIENT_ID');
  if (clientId.isEmpty || clientId == 'debug') {
    throw Exception(
      'CLIENT_ID must be provided and must not be "debug" for STAGING.\n'
      'Did you launch with: flutter run --dart-define=CLIENT_ID=... --flavor staging --target lib/main_staging.dart?',
    );
  }
  // Log details
  if (kDebugMode) {
    print('[STAGING] Launching Memverse App');
    print('[STAGING] API Base URL: $apiBaseUrl');
    print('[STAGING] CLIENT_ID: $clientId');
  }
  bootstrap(() => const App());
}
