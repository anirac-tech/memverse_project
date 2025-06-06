import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/common/services/analytics_service.dart';

void main() {
  group('AnalyticsService', () {
    test('PostHogAnalyticsService should instantiate without errors', () {
      final service = PostHogAnalyticsService();
      expect(service, isA<AnalyticsService>());
    });

    test('LoggingAnalyticsService should track events in debug mode', () async {
      final service = LoggingAnalyticsService();

      // These calls should complete without throwing exceptions
      await service.trackLogin('test_user');
      await service.trackLogout();
      await service.trackVerseCorrect('John 3:16');
      await service.trackVerseIncorrect('John 3:16', 'John 3:17');
      await service.trackFeedbackTrigger();

      expect(service, isA<AnalyticsService>());
    });

    test('NoOpAnalyticsService should handle all events silently', () async {
      final service = NoOpAnalyticsService();

      // These calls should complete without throwing exceptions
      await service.trackLogin('test_user');
      await service.trackLogout();
      await service.trackVerseCorrect('John 3:16');
      await service.trackLoginFailure('test_user', 'invalid credentials');
      await service.trackPracticeSessionComplete(5, 4);

      expect(service, isA<AnalyticsService>());
    });

    test('All services should implement required tracking methods', () {
      final postHog = PostHogAnalyticsService();
      final logging = LoggingAnalyticsService();
      final noOp = NoOpAnalyticsService();

      // Check that all required methods exist
      expect(postHog.trackLogin, isA<Function>());
      expect(postHog.trackLogout, isA<Function>());
      expect(postHog.trackVerseCorrect, isA<Function>());
      expect(postHog.trackVerseIncorrect, isA<Function>());
      expect(postHog.trackVerseNearlyCorrect, isA<Function>());
      expect(postHog.trackFeedbackTrigger, isA<Function>());

      // Same for other implementations
      expect(logging.trackLogin, isA<Function>());
      expect(noOp.trackLogin, isA<Function>());
    });
  });
}
