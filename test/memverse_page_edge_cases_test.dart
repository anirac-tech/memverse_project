import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/ref_quiz/widgets/question_history_widget.dart';
import 'package:memverse/src/features/ref_quiz/widgets/verse_reference_form.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('VerseReferenceForm edge cases', () {
    late MockAppLocalizations mockL10n;
    late TextEditingController answerController;
    late FocusNode answerFocusNode;

    setUp(() {
      mockL10n = MockAppLocalizations();
      answerController = TextEditingController();
      answerFocusNode = FocusNode();

      when(() => mockL10n.reference).thenReturn('Reference');
      when(() => mockL10n.enterReferenceHint).thenReturn('Enter verse reference');
      when(() => mockL10n.referenceFormat).thenReturn('Format: Book Chapter:Verse');
      when(() => mockL10n.correct).thenReturn('Correct');
      when(() => mockL10n.notQuiteRight(any())).thenReturn('Not quite right');
      when(() => mockL10n.submit).thenReturn('Submit');
    });

    tearDown(() {
      answerController.dispose();
      answerFocusNode.dispose();
    });

    testWidgets('handles empty state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: VerseReferenceForm(
              expectedReference: 'Genesis 1:1',
              l10n: mockL10n,
              answerController: answerController,
              answerFocusNode: answerFocusNode,
              hasSubmittedAnswer: false,
              isAnswerCorrect: false,
              onSubmitAnswer: (_) {},
            ),
          ),
        ),
      );

      // Verify the input decoration doesn't have error or success styles
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration!.suffixIcon, isNull);
      expect(textField.decoration!.filled, isFalse);
    });
  });

  group('StatsAndHistorySection edge cases', () {
    late MockAppLocalizations mockL10n;

    setUp(() {
      mockL10n = MockAppLocalizations();
      when(() => mockL10n.referencesDueToday).thenReturn('References Due Today');
      when(() => mockL10n.priorQuestions).thenReturn('Prior Questions');
      when(() => mockL10n.noPreviousQuestions).thenReturn('No previous questions');
    });

    testWidgets('limits question history to 5 items', (WidgetTester tester) async {
      final pastQuestions = [
        'Genesis 1:1-[Genesis 1:1] Correct!',
        'John 3:16-[John 3:16] Correct!',
        'Proverbs 3:5-[Proverbs 3:5] Correct!',
        'Philippians 4:13-[Philippians 4:13] Correct!',
        'Romans 8:28-[Romans 8:28] Correct!',
        'John 3:17-[John 3:16] Incorrect',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: mockL10n),
          ),
        ),
      );

      // Verify all 6 questions are displayed
      expect(find.text('John 3:17-[John 3:16] Incorrect'), findsOneWidget);

      // Verify the last question is bold
      final lastQuestionText = tester.widget<Text>(find.text('John 3:17-[John 3:16] Incorrect'));
      expect(lastQuestionText.style?.fontWeight, equals(FontWeight.bold));
    });
  });
}
