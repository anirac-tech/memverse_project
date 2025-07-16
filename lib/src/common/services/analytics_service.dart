import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/utils/app_logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Environment configuration for analytics
enum AnalyticsEnvironment {
  production('prd', 'https://api.memverse.com'),
  staging('stg', 'https://api-stg.memverse.com'),
  development('dev', 'https://api-dev.memverse.com');

  const AnalyticsEnvironment(this.key, this.apiUrl);

  final String key;
  final String apiUrl;

  static AnalyticsEnvironment fromApiUrl(String apiUrl) {
    for (final env in values) {
      if (env.apiUrl == apiUrl) return env;
    }
    return development; // Default fallback
  }
}

/// Entry point identification for analytics
enum AnalyticsEntryPoint {
  mainDevelopment('main_development'),
  mainStaging('main_staging'),
  mainProduction('main_production');

  const AnalyticsEntryPoint(this.key);

  final String key;
}

/// Abstract interface for analytics tracking
abstract class AnalyticsService {
  /// Initialize the analytics service
  Future<void> init({String? apiKey, AnalyticsEntryPoint? entryPoint, String? flavor});

  /// Track a user event with optional properties
  Future<void> track(String eventName, {Map<String, dynamic>? properties});

  /// Track user login event
  Future<void> trackLogin(String username) =>
      track('user_login', properties: {'username': username});

  /// Track user logout event
  Future<void> trackLogout() => track('user_logout');

  /// Track login failure after network call
  Future<void> trackLoginFailure(String username, String error) =>
      track('login_failure_after_network_call', properties: {'username': username, 'error': error});

  /// Track feedback trigger event
  Future<void> trackFeedbackTrigger() => track('feedback_trigger');

  /// Track verse answer - correct
  Future<void> trackVerseCorrect(String verseReference) =>
      track('verse_correct', properties: {'verse_reference': verseReference});

  /// Track verse answer - incorrect
  Future<void> trackVerseIncorrect(String verseReference, String userAnswer) => track(
    'verse_incorrect',
    properties: {'verse_reference': verseReference, 'user_answer': userAnswer},
  );

  /// Track verse answer - nearly correct
  Future<void> trackVerseNearlyCorrect(String verseReference, String userAnswer) => track(
    'verse_nearly_correct',
    properties: {'verse_reference': verseReference, 'user_answer': userAnswer},
  );

  /// Track verse displayed
  Future<void> trackVerseDisplayed(String verseReference) =>
      track('verse_displayed', properties: {'verse_reference': verseReference});

  /// Track app opened
  Future<void> trackAppOpened() => track('app_opened');

  /// Track navigation events
  Future<void> trackNavigation(String fromScreen, String toScreen) =>
      track('navigation', properties: {'from_screen': fromScreen, 'to_screen': toScreen});

  /// Track verse practice session start
  Future<void> trackPracticeSessionStart() => track('practice_session_start');

  /// Track verse practice session complete
  Future<void> trackPracticeSessionComplete(int versesAnswered, int correctAnswers) => track(
    'practice_session_complete',
    properties: {
      'verses_answered': versesAnswered,
      'correct_answers': correctAnswers,
      'accuracy': correctAnswers / versesAnswered,
    },
  );

  /// Track when verse list cycles back to the beginning
  Future<void> trackVerseListCycled(int totalVerses, int cycleCount) => track(
    'verse_list_cycled',
    properties: {'total_verses': totalVerses, 'cycle_count': cycleCount},
  );

  /// Track successful API call for verses
  Future<void> trackVerseApiSuccess(int verseCount, int responseTime) => track(
    'verse_api_success',
    properties: {'verse_count': verseCount, 'response_time_ms': responseTime},
  );

  /// Track failed API call for verses
  Future<void> trackVerseApiFailure(String errorType, String errorMessage) => track(
    'verse_api_failure',
    properties: {'error_type': errorType, 'error_message': errorMessage},
  );

  /// Track password visibility toggle
  Future<void> trackPasswordVisibilityToggle(bool isVisible) =>
      track('password_visibility_toggle', properties: {'is_visible': isVisible});

  /// Track form validation failures
  Future<void> trackValidationFailure(String field, String error) =>
      track('validation_failure', properties: {'field': field, 'error': error});

  /// Track empty username validation
  Future<void> trackEmptyUsernameValidation() =>
      track('empty_username_validation', properties: {'field': 'username', 'error': 'empty'});

  /// Track empty password validation
  Future<void> trackEmptyPasswordValidation() =>
      track('empty_password_validation', properties: {'field': 'password', 'error': 'empty'});

  /// Track web-specific events
  Future<void> trackWebPageView(String pageName) =>
      track('web_page_view', properties: {'page_name': pageName, 'platform': 'web'});

  /// Track web browser information
  Future<void> trackWebBrowserInfo(String userAgent) =>
      track('web_browser_info', properties: {'user_agent': userAgent, 'platform': 'web'});

  /// Track web performance metrics
  Future<void> trackWebPerformance(int loadTime, String pageName) => track(
    'web_performance',
    properties: {'load_time_ms': loadTime, 'page_name': pageName, 'platform': 'web'},
  );
}

/// PostHog implementation of analytics service
class PostHogAnalyticsService extends AnalyticsService {
  factory PostHogAnalyticsService() => _instance;

  PostHogAnalyticsService._internal();

  static final PostHogAnalyticsService _instance = PostHogAnalyticsService._internal();

  bool _isInitialized = false;

  @override
  Future<void> init({String? apiKey, AnalyticsEntryPoint? entryPoint, String? flavor}) async {
    if (_isInitialized) {
      AppLogger.i('PostHog analytics already initialized');
      return;
    }

    if (apiKey?.isEmpty ?? true) {
      AppLogger.e('❌ PostHog API key is not provided');
      AppLogger.e('   Received API key length: ${apiKey?.length ?? 0}');
      return;
    }

    try {
      AppLogger.i('🔧 Initializing PostHog analytics...');
      AppLogger.i('   API Key length: ${apiKey!.length}');
      AppLogger.i('   Entry Point: ${entryPoint?.key}');
      AppLogger.i('   Flavor: $flavor');
      AppLogger.i('   Platform: ${kIsWeb ? 'web' : Platform.operatingSystem}');

      final config = PostHogConfig(apiKey)
        ..host = 'https://us.i.posthog.com'
        ..debug = kDebugMode
        ..captureApplicationLifecycleEvents = true;

      // Simplified platform configuration - avoid complex session replay on Android
      if (kIsWeb) {
        AppLogger.i('🌐 Configuring for web platform...');
        config.sessionReplay = true;
        config.sessionReplayConfig.maskAllTexts = false;
        config.sessionReplayConfig.maskAllTexts = false;
      } else if (Platform.isAndroid) {
        AppLogger.i('🤖 Configuring for Android platform...');
        // Keep Android configuration minimal for reliability
        config.sessionReplay = false;
      } else if (Platform.isIOS) {
        AppLogger.i('🍎 Configuring for iOS platform...');
        config.sessionReplay = true;
        config.sessionReplayConfig.maskAllTexts = false;
        config.sessionReplayConfig.maskAllImages = false;
      }

      // Setup PostHog with simplified error handling
      AppLogger.i('📡 Setting up PostHog connection...');
      await Posthog().setup(config);

      AppLogger.i('✅ PostHog setup completed successfully');
      _isInitialized = true;

      // Register basic properties only
      AppLogger.i('📋 Registering analytics properties...');
      await _registerBasicProperties(entryPoint, flavor);

      AppLogger.i('🎉 PostHog analytics fully initialized and ready!');
      AppLogger.i('🔍 Singleton instance initialized: ${_instance.hashCode}');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Failed to initialize PostHog analytics: $e');
      AppLogger.e('📋 Stack trace: $stackTrace');
      _isInitialized = false;

      // Set a flag to use logging instead
      AppLogger.w('⚠️ Falling back to logging-only analytics mode');
    }
  }

  Future<void> _registerBasicProperties(AnalyticsEntryPoint? entryPoint, String? flavor) async {
    try {
      // Register only essential properties to avoid Android issues
      await Posthog().register('entry_point', entryPoint?.key ?? 'unknown');
      await Posthog().register('app_flavor', flavor ?? 'unknown');
      await Posthog().register('debug_mode', kDebugMode.toString());
      await Posthog().register('platform', kIsWeb ? 'web' : Platform.operatingSystem);

      AppLogger.i('✅ Basic properties registered successfully');

      // Try to register device type with timeout
      if (!kIsWeb) {
        try {
          if (Platform.isAndroid) {
            await Posthog().register('device_type', 'android');
          } else if (Platform.isIOS) {
            await Posthog().register('device_type', 'ios');
          }
        } catch (e) {
          AppLogger.w('Device type registration failed (non-critical): $e');
        }
      }
    } catch (e) {
      AppLogger.w('Property registration failed: $e');
      // Don't fail initialization for property registration issues
    }
  }

  @override
  Future<void> track(String eventName, {Map<String, dynamic>? properties}) async {
    AppLogger.d('🔍 Track called on instance: $hashCode, initialized: $_isInitialized');

    if (!_isInitialized) {
      AppLogger.w('⚠️ PostHog not initialized, cannot track event: $eventName');
      AppLogger.w('   This usually means the API key was not provided or initialization failed');
      AppLogger.w('   Instance hash: $hashCode');
      return;
    }

    try {
      AppLogger.d('📊 Tracking event: $eventName');
      if (properties != null && properties.isNotEmpty) {
        AppLogger.d('   Properties: $properties');
      }

      await Posthog().capture(eventName: eventName, properties: properties?.cast<String, Object>());
      AppLogger.d('✅ Successfully tracked: $eventName');
    } catch (e) {
      AppLogger.e('❌ Failed to track event $eventName: $e');
      // Don't let analytics failures crash the app
    }
  }

  Future<bool> _isAndroidEmulator() async {
    try {
      // Try multiple methods to detect Android emulator
      final result = await Process.run('getprop', [
        'ro.kernel.qemu',
      ]).timeout(const Duration(seconds: 2), onTimeout: () => ProcessResult(0, 1, '', 'timeout'));

      if (result.exitCode == 0 && result.stdout.toString().trim() == '1') {
        return true;
      }

      final buildFingerprint = await Process.run('getprop', [
        'ro.build.fingerprint',
      ]).timeout(const Duration(seconds: 2), onTimeout: () => ProcessResult(0, 1, '', 'timeout'));

      if (buildFingerprint.exitCode == 0) {
        final fingerprint = buildFingerprint.stdout.toString().toLowerCase();
        return fingerprint.contains('generic') ||
            fingerprint.contains('emulator') ||
            fingerprint.contains('sdk');
      }

      return false;
    } catch (e) {
      AppLogger.w('Could not detect Android emulator: $e');
      return false;
    }
  }

  Future<bool> _isIOSSimulator() async {
    try {
      final envResult = await Process.run('printenv', [
        'SIMULATOR_DEVICE_NAME',
      ]).timeout(const Duration(seconds: 2), onTimeout: () => ProcessResult(0, 1, '', 'timeout'));
      return envResult.exitCode == 0 && envResult.stdout.toString().isNotEmpty;
    } catch (e) {
      AppLogger.w('Could not detect iOS simulator: $e');
      return false;
    }
  }
}

/// Logging implementation of analytics service for debug/testing
class LoggingAnalyticsService extends AnalyticsService {
  @override
  Future<void> init({String? apiKey, AnalyticsEntryPoint? entryPoint, String? flavor}) async {
    if (kDebugMode) {
      AppLogger.d(
        '📊 Analytics: Logging service initialized - Entry: ${entryPoint?.key}, Flavor: $flavor',
      );
    }
  }

  @override
  Future<void> track(String eventName, {Map<String, dynamic>? properties}) async {
    if (kDebugMode) {
      AppLogger.d('📊 Analytics: $eventName${properties != null ? ' - $properties' : ''}');
    }
  }
}

/// No-op implementation of analytics service for testing
class NoOpAnalyticsService extends AnalyticsService {
  @override
  Future<void> init({String? apiKey, AnalyticsEntryPoint? entryPoint, String? flavor}) async {
    // Do nothing
  }

  @override
  Future<void> track(String eventName, {Map<String, dynamic>? properties}) async {
    // Do nothing
  }
}

/// Provider for the analytics service
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final clientId = ref.read(bootstrapProvider).clientId;
  if (clientId.isEmpty || clientId == 'debug') {
    return LoggingAnalyticsService();
  }
  return PostHogAnalyticsService();
});
