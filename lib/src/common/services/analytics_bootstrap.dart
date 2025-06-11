import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/utils/app_logger.dart';

/// Bootstrap analytics initialization for all entry points and flavors
class AnalyticsBootstrap {
  static bool _isInitialized = false;

  /// Initialize analytics for any entry point with proper configuration
  static Future<void> initialize({
    required AnalyticsEntryPoint entryPoint,
    required String flavor,
    String? customApiKey,
    String? memverseApiUrl,
  }) async {
    if (_isInitialized) {
      AppLogger.w('Analytics already initialized, skipping duplicate initialization');
      return;
    }

    try {
      AppLogger.i('🚀 Starting analytics initialization...');
      AppLogger.i('📍 Entry Point: ${entryPoint.key}');
      AppLogger.i('🏷️ Flavor: $flavor');
      AppLogger.i('🌐 API URL: $memverseApiUrl');

      // Determine environment from API URL or default to development
      final environment = memverseApiUrl != null
          ? AnalyticsEnvironment.fromApiUrl(memverseApiUrl)
          : AnalyticsEnvironment.development;

      AppLogger.i('🌍 Determined environment: ${environment.key} (${environment.apiUrl})');

      // Get PostHog API key - allow override per environment/flavor if needed
      final apiKey = customApiKey ?? _getPostHogApiKey(entryPoint, flavor, environment);

      AppLogger.i(
        '🔑 API Key check: ${apiKey?.isNotEmpty == true ? "API key provided" : "NO API KEY FOUND"}',
      );

      if (apiKey?.isEmpty ?? true) {
        AppLogger.e('❌ Analytics initialization failed: No PostHog API key provided');
        AppLogger.e('💡 Make sure POSTHOG_MEMVERSE_API_KEY environment variable is set');
        return;
      }

      AppLogger.i('🔧 Creating analytics service...');
      // Initialize analytics service
      final container = ProviderContainer();
      final analyticsService = container.read(analyticsServiceProvider);

      AppLogger.i('📡 Calling analytics service init...');
      await analyticsService.init(
        apiKey: apiKey,
        entryPoint: entryPoint,
        flavor: flavor,
        environment: environment,
      );

      _isInitialized = true;

      AppLogger.i('✅ Analytics initialized successfully');
      AppLogger.i('📊 Entry Point: ${entryPoint.key}');
      AppLogger.i('🏷️  Flavor: $flavor');
      AppLogger.i('🌍 Environment: ${environment.key} (${environment.apiUrl})');

      // Track app initialization
      AppLogger.i('📈 Tracking app opened event...');
      await analyticsService.trackAppOpened();
      AppLogger.i('🎯 App opened event tracked successfully');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Analytics initialization failed: $e');
      AppLogger.e('📋 Stack trace: $stackTrace');
    }
  }

  /// Get PostHog API key based on configuration
  /// In the future, this can return different keys for different environments
  static String? _getPostHogApiKey(
    AnalyticsEntryPoint entryPoint,
    String flavor,
    AnalyticsEnvironment environment,
  ) {
    // For now, use the same project for all environments
    // Future enhancement: return different keys based on:
    // - environment (prod/staging/dev)
    // - flavor (development/staging/production)
    // - entry point (for A/B testing different app versions)

    const apiKey = String.fromEnvironment('POSTHOG_MEMVERSE_API_KEY');

    AppLogger.i('🔍 Checking environment variables:');
    AppLogger.i('   POSTHOG_MEMVERSE_API_KEY length: ${apiKey.length}');
    AppLogger.i('   CLIENT_ID length: ${const String.fromEnvironment('CLIENT_ID').length}');
    AppLogger.i(
      '   ENVIRONMENT: ${const String.fromEnvironment('ENVIRONMENT', defaultValue: 'not_set')}',
    );

    if (kDebugMode && apiKey.isNotEmpty) {
      AppLogger.d(
        '🔑 Using PostHog API key for ${environment.key} environment (${apiKey.substring(0, 8)}...)',
      );
    }

    return apiKey.isEmpty ? null : apiKey;
  }

  /// Reset initialization state (for testing)
  static void reset() {
    _isInitialized = false;
  }

  /// Check if analytics is initialized
  static bool get isInitialized => _isInitialized;
}
