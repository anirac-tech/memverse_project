import 'package:flutter/foundation.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/utils/app_logger.dart';

void main() async {
  const clientId = String.fromEnvironment('CLIENT_ID');
  if (clientId.isEmpty || clientId == 'debug') {
    throw Exception(
      'CLIENT_ID must be provided and must not be "debug" for PRODUCTION.\n'
      'Did you launch with: flutter run --dart-define=CLIENT_ID=... --flavor production --target lib/main_production.dart?',
    );
  }
  // Log details
  if (kDebugMode) {
    AppLogger.i('[PRODUCTION] Launching Memverse App');
    AppLogger.i('[PRODUCTION] CLIENT_ID: $clientId');
  }
  bootstrap(() => const App());
}
