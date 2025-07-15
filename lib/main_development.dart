import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/common/services/analytics_bootstrap.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/utils/app_logger.dart';

String _getMemverseApiUrl() {
  const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  switch (environment) {
    case 'prd':
      return 'https://api.memverse.com';
    case 'stg':
      return 'https://api-stg.memverse.com';
    case 'dev':
    default:
      return 'https://api-dev.memverse.com';
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const bool autoSignIn = bool.fromEnvironment('AUTOSIGNIN', defaultValue: true);

  if (autoSignIn) {
    AuthService.isDummyUser = true;
  }

  // Web-specific PostHog initialization is handled by analytics service
  if (kIsWeb) {
    AppLogger.i('Web platform detected - PostHog will be initialized by analytics service');
  }

  final apiUrl = _getMemverseApiUrl();
  AppLogger.i('🌍 Using API URL: $apiUrl');
  AppLogger.i(
    '🏷️  Environment: ${const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev')}',
  );
  AppLogger.i(
    '🔑 PostHog API Key available: ${const String.fromEnvironment('POSTHOG_MEMVERSE_API_KEY').isNotEmpty}',
  );

  // Initialize analytics with bootstrap
  await AnalyticsBootstrap.initialize(
    entryPoint: AnalyticsEntryPoint.mainDevelopment,
    flavor: 'development',
  );

  bootstrap(() => const ProviderScope(child: App()));
}
