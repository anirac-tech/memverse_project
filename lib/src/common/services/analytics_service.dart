import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/utils/app_logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Abstract interface for analytics tracking
abstract class AnalyticsService {
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
}

/// PostHog implementation of analytics service
class PostHogAnalyticsService extends AnalyticsService {
  @override
  Future<void> track(String eventName, {Map<String, dynamic>? properties}) async {
    try {
      await Posthog().capture(eventName: eventName, properties: properties?.cast<String, Object>());
    } catch (e) {
      // Silently fail - don't let analytics crash the app
      if (kDebugMode) {
        AppLogger.d('Analytics tracking failed for event $eventName: $e');
      }
    }
  }
}

/// Logging implementation of analytics service for debug/testing
class LoggingAnalyticsService extends AnalyticsService {
  @override
  Future<void> track(String eventName, {Map<String, dynamic>? properties}) async {
    if (kDebugMode) {
      debugPrint('📊 Analytics: $eventName${properties != null ? ' - $properties' : ''}');
    }
  }
}

/// No-op implementation of analytics service for testing
class NoOpAnalyticsService extends AnalyticsService {
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
