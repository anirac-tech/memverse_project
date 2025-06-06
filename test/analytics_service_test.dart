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

    test('LoggingAnalyticsService should track new password and validation events', () async {
      final service = LoggingAnalyticsService();

      // Test new password visibility events
      await service.trackPasswordVisibilityToggle(true);
      await service.trackPasswordVisibilityToggle(false);

      // Test new validation events
      await service.trackEmptyUsernameValidation();
      await service.trackEmptyPasswordValidation();
      await service.trackValidationFailure('username', 'required');

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

      // Test new events
      await service.trackPasswordVisibilityToggle(true);
      await service.trackEmptyUsernameValidation();
      await service.trackEmptyPasswordValidation();

      expect(service, isA<AnalyticsService>());
    });

    test('All services should implement required tracking methods', () {
      final postHog = PostHogAnalyticsService();
      final logging = LoggingAnalyticsService();
      final noOp = NoOpAnalyticsService();

      // Check that all required methods exist (original)
      expect(postHog.trackLogin, isA<Function>());
      expect(postHog.trackLogout, isA<Function>());
      expect(postHog.trackVerseCorrect, isA<Function>());
      expect(postHog.trackVerseIncorrect, isA<Function>());
      expect(postHog.trackVerseNearlyCorrect, isA<Function>());
      expect(postHog.trackFeedbackTrigger, isA<Function>());

      // Check new methods exist
      expect(postHog.trackPasswordVisibilityToggle, isA<Function>());
      expect(postHog.trackEmptyUsernameValidation, isA<Function>());
      expect(postHog.trackEmptyPasswordValidation, isA<Function>());
      expect(postHog.trackValidationFailure, isA<Function>());

      // Same for other implementations
      expect(logging.trackLogin, isA<Function>());
      expect(logging.trackPasswordVisibilityToggle, isA<Function>());
      expect(noOp.trackLogin, isA<Function>());
      expect(noOp.trackEmptyUsernameValidation, isA<Function>());
    });
  });
}
