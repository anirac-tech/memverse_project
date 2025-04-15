import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/presentation/widgets/question_history_widget.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late MockAppLocalizations mockL10n;

  setUp(() {
    mockL10n = MockAppLocalizations();
    when(() => mockL10n.priorQuestions).thenReturn('Prior Questions');
    when(() => mockL10n.noPreviousQuestions).thenReturn('No previous questions');
  });

  group('QuestionHistoryWidget', () {
    testWidgets('shows "no previous questions" when pastQuestions is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      const pastQuestions = <String>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: mockL10n)),
        ),
      );

      // Assert
      expect(find.text('Prior Questions'), findsOneWidget);
      expect(find.text('No previous questions'), findsOneWidget);
      expect(find.byKey(const Key('past-questions')), findsOneWidget);
    });

    testWidgets('shows list of past questions when available', (WidgetTester tester) async {
      // Arrange
      const pastQuestions = <String>[
        'Genesis 1:1-[Genesis 1:1] Correct!',
        'John 3:16-[John 3:16] Correct!',
        'Romans 8:28-[Romans 8:29] Incorrect',
      ];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: mockL10n)),
        ),
      );

      // Assert
      expect(find.text('Prior Questions'), findsOneWidget);
      expect(find.text('No previous questions'), findsNothing);
      expect(find.text('Genesis 1:1-[Genesis 1:1] Correct!'), findsOneWidget);
      expect(find.text('John 3:16-[John 3:16] Correct!'), findsOneWidget);
      expect(find.text('Romans 8:28-[Romans 8:29] Incorrect'), findsOneWidget);
    });

    testWidgets('correct answers have green text color', (WidgetTester tester) async {
      // Arrange
      const pastQuestions = <String>['Genesis 1:1-[Genesis 1:1] Correct!'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: mockL10n)),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('Genesis 1:1-[Genesis 1:1] Correct!'));
      expect(textWidget.style?.color, Colors.green);
    });

    testWidgets('incorrect answers have orange text color', (WidgetTester tester) async {
      // Arrange
      const pastQuestions = <String>['Romans 8:28-[Romans 8:29] Incorrect'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: mockL10n)),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('Romans 8:28-[Romans 8:29] Incorrect'));
      expect(textWidget.style?.color, Colors.orange);
    });

    testWidgets('most recent answer has bold text', (WidgetTester tester) async {
      // Arrange
      const pastQuestions = <String>[
        'Genesis 1:1-[Genesis 1:1] Correct!',
        'John 3:16-[John 3:16] Correct!',
        'Romans 8:28-[Romans 8:29] Incorrect',
      ];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: mockL10n)),
        ),
      );

      // Assert - most recent item should have bold text
      final mostRecentText = tester.widget<Text>(find.text('Romans 8:28-[Romans 8:29] Incorrect'));
      expect(mostRecentText.style?.fontWeight, FontWeight.bold);

      // Older items should have normal font weight
      final olderText = tester.widget<Text>(find.text('Genesis 1:1-[Genesis 1:1] Correct!'));
      expect(olderText.style?.fontWeight, FontWeight.normal);
    });
  });
}
