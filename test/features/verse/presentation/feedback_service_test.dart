import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/presentation/feedback_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Mocks
class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  // --- Existing Unit Tests Group ---
  group('FeedbackService Unit Tests', () {
    late FeedbackService feedbackService;

    setUp(() {
      feedbackService = FeedbackService();
    });

    group('truncateText', () {
      test('should not truncate short text', () {
        const text = 'This is short text.';
        expect(feedbackService.truncateText(text, 50), equals(text));
      });

      test('should truncate long text', () {
        const text =
            'This is a very long piece of text that definitely needs to be truncated because it exceeds the maximum length.';
        const maxLength = 50;
        final truncated = feedbackService.truncateText(text, maxLength);
        expect(truncated.length, lessThanOrEqualTo(maxLength + 3)); // Allow for '...'
        expect(truncated.endsWith('...'), isTrue);
      });

      test('should truncate at last space if possible', () {
        const text = 'This is a long text string designed to test word boundary truncation nicely.';
        const maxLength = 50;
        final truncated = feedbackService.truncateText(text, maxLength);
        expect(truncated, equals('This is a long text string designed to test word...'));
      });

      test('should truncate mid-word if no suitable space', () {
        const text = ' veryverylongwordthatcannotbebrokenatotallyreasonablepoint.';
        const maxLength = 30;
        final truncated = feedbackService.truncateText(text, maxLength);
        expect(truncated, equals(' veryverylongwordthatcannotbeb...')); // Truncates at maxLength
      });
    });

    group('generateSubject', () {
      test('should generate subject with short feedback', () {
        const feedback = 'Simple feedback.';
        expect(
          feedbackService.generateSubject(feedback),
          equals('Memverse Feedback: Simple feedback.'),
        );
      });

      test('should generate subject with long feedback, truncating feedback part', () {
        const feedback =
            'This feedback is extremely long and will certainly exceed the internal limit set for the subject line content.';
        expect(
          feedbackService.generateSubject(feedback),
          equals('Memverse Feedback: This feedback is extremely long and will...'),
        );
      });

      test('should replace newlines with spaces before truncating', () {
        const feedback =
            'Line one feedback.\nLine two feedback is much longer and might get truncated.';
        expect(
          feedbackService.generateSubject(feedback),
          equals('Memverse Feedback: Line one feedback. Line two feedback is much...'),
        );
      });
    });

    group('handleFeedbackSubmission path provider', () {
      late MockPathProviderPlatform mockPathProvider;

      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized();
        mockPathProvider = MockPathProviderPlatform();
        PathProviderPlatform.instance = mockPathProvider;

        when(() => mockPathProvider.getTemporaryPath()).thenAnswer((_) async => '/tmp');
      });

      test('uses path provider to get temporary directory', () async {
        // Arrange
        final mockContext = MockBuildContext();
        when(() => mockContext.mounted).thenReturn(true);

        final feedback = UserFeedback(
          text: 'Test feedback',
          screenshot: Uint8List.fromList([1, 2, 3]),
        );

        // Act - Let errors be caught in the service
        try {
          await feedbackService.handleFeedbackSubmission(mockContext, feedback);
        } catch (_) {
          // Ignore platform errors - we're just testing path provider interaction
        }

        // Assert
        verify(() => mockPathProvider.getTemporaryPath()).called(1);
      });

      test('handles path provider errors gracefully', () async {
        // Arrange - Make path provider throw
        when(
          () => mockPathProvider.getTemporaryPath(),
        ).thenAnswer((_) async => throw Exception('Cannot access directory'));

        final mockContext = MockBuildContext();
        // Explicitly mock mounted for this context
        when(() => mockContext.mounted).thenReturn(true);

        final feedback = UserFeedback(
          text: 'Test feedback',
          screenshot: Uint8List.fromList([1, 2, 3]),
        );

        // Act & Assert - Should not throw
        await expectLater(
          () => feedbackService.handleFeedbackSubmission(mockContext, feedback),
          returnsNormally,
        );

        // Verify path provider was called
        verify(() => mockPathProvider.getTemporaryPath()).called(1);
      });
    });
  });
}
