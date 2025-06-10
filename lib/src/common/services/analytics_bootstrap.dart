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
      // Determine environment from API URL or default to development
      final environment = memverseApiUrl != null
          ? AnalyticsEnvironment.fromApiUrl(memverseApiUrl)
          : AnalyticsEnvironment.development;

      // Get PostHog API key - allow override per environment/flavor if needed
      final apiKey = customApiKey ?? _getPostHogApiKey(entryPoint, flavor, environment);

      if (apiKey?.isEmpty ?? true) {
        AppLogger.e('❌ Analytics initialization failed: No PostHog API key provided');
        return;
      }

      // Initialize analytics service
      final container = ProviderContainer();
      final analyticsService = container.read(analyticsServiceProvider);

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
      await analyticsService.trackAppOpened();
    } catch (e) {
      AppLogger.e('❌ Analytics initialization failed: $e');
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

    if (kDebugMode && apiKey.isNotEmpty) {
      AppLogger.d('🔑 Using PostHog API key for ${environment.key} environment');
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
