import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/utils/app_logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Abstract interface for analytics tracking
abstract class AnalyticsService {
  /// Initialize the analytics service
  Future<void> init({String? apiKey});

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
  bool _isInitialized = false;

  @override
  Future<void> init({String? apiKey}) async {
    if (_isInitialized) return;

    if (apiKey?.isEmpty ?? true) {
      AppLogger.e('Error: PostHog API key is not provided');
      return;
    }

    try {
      if (kDebugMode) {
        AppLogger.d('PostHog API Key: $apiKey');
      }

      // Web-specific initialization
      if (kIsWeb) {
        try {
          // Call the JavaScript initialization function
          // Note: This requires js import in the calling code
          AppLogger.i('PostHog JavaScript SDK would be initialized for web');
        } catch (e) {
          AppLogger.e('Failed to initialize PostHog JavaScript SDK: $e');
        }
      }

      final config = PostHogConfig(apiKey!);
      config.host = 'https://us.i.posthog.com';
      config.debug = kDebugMode;
      config.captureApplicationLifecycleEvents = true;

      // Platform-specific configuration
      if (kIsWeb) {
        config.sessionReplay = true;
        config.sessionReplayConfig.maskAllTexts = false;
        config.sessionReplayConfig.maskAllImages = false;
        AppLogger.i('PostHog configured for web with session replay enabled');
      } else {
        config.sessionReplay = true;
        config.sessionReplayConfig.maskAllTexts = false;
        config.sessionReplayConfig.maskAllImages = false;
        AppLogger.i('PostHog configured for mobile with session replay');
      }

      // Setup PostHog with the given Context and Config
      await Posthog().setup(config);
      _isInitialized = true;

      // Register custom properties for analytics tracking
      await Posthog().register('app_flavor', 'development');
      await Posthog().register('debug_mode', kDebugMode.toString());
      await Posthog().register('platform', kIsWeb ? 'web' : Platform.operatingSystem);

      // Detect and register emulator/simulator status
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          final isEmulator = await _isAndroidEmulator();
          await Posthog().register('is_emulator', isEmulator.toString());
          await Posthog().register('is_simulator', 'false');
        } else if (Platform.isIOS) {
          final isSimulator = await _isIOSSimulator();
          await Posthog().register('is_emulator', 'false');
          await Posthog().register('is_simulator', isSimulator.toString());
        } else {
          await Posthog().register('is_emulator', 'false');
          await Posthog().register('is_simulator', 'false');
        }
      } else {
        await Posthog().register('is_emulator', 'false');
        await Posthog().register('is_simulator', 'false');
      }

      AppLogger.i('PostHog properties registered for development flavor');

      if (kIsWeb) {
        AppLogger.i('PostHog web analytics fully initialized - JS + Flutter SDK ready');
      }
    } catch (e) {
      AppLogger.e('Failed to initialize PostHog analytics: $e');
    }
  }

  @override
  Future<void> track(String eventName, {Map<String, dynamic>? properties}) async {
    if (!_isInitialized) {
      if (kDebugMode) {
        AppLogger.w('Analytics not initialized, skipping event: $eventName');
      }
      return;
    }

    try {
      await Posthog().capture(eventName: eventName, properties: properties?.cast<String, Object>());
    } catch (e) {
      // Silently fail - don't let analytics crash the app
      if (kDebugMode) {
        AppLogger.d('Analytics tracking failed for event $eventName: $e');
      }
    }
  }

  Future<bool> _isAndroidEmulator() async {
    try {
      final result = await Process.run('getprop', ['ro.kernel.qemu']);
      if (result.stdout.toString().trim() == '1') return true;

      final buildFingerprint = await Process.run('getprop', ['ro.build.fingerprint']);
      final fingerprint = buildFingerprint.stdout.toString().toLowerCase();

      return fingerprint.contains('generic') ||
          fingerprint.contains('emulator') ||
          fingerprint.contains('sdk');
    } catch (e) {
      AppLogger.w('Could not detect Android emulator: $e');
      return false;
    }
  }

  Future<bool> _isIOSSimulator() async {
    try {
      final envResult = await Process.run('printenv', ['SIMULATOR_DEVICE_NAME']);
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
  Future<void> init({String? apiKey}) async {
    if (kDebugMode) {
      AppLogger.d('📊 Analytics: Logging service initialized');
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
  Future<void> init({String? apiKey}) async {
    // Do nothing
  }

  @override
  Future<void> track(String eventName, {Map<String, dynamic>? properties}) async {
    // Do nothing
  }
}

/// Provider for the analytics service
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  // Return PostHog analytics for production
  // Can be easily overridden for testing or debug modes
  return PostHogAnalyticsService();
});
