import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/presentation/widgets/verse_reference_form.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('VerseReferenceForm', () {
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

    testWidgets('should display reference input form', (WidgetTester tester) async {
      var submitCalled = false;

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
              onSubmitAnswer: (_) {
                submitCalled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Reference'), findsOneWidget);
      expect(find.text('Format: Book Chapter:Verse'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      expect(submitCalled, isTrue);
    });

    testWidgets('should show correct state when answer is correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: VerseReferenceForm(
              expectedReference: 'Genesis 1:1',
              l10n: mockL10n,
              answerController: answerController,
              answerFocusNode: answerFocusNode,
              hasSubmittedAnswer: true,
              isAnswerCorrect: true,
              onSubmitAnswer: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Correct'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should show incorrect state when answer is wrong', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: VerseReferenceForm(
              expectedReference: 'Genesis 1:1',
              l10n: mockL10n,
              answerController: answerController,
              answerFocusNode: answerFocusNode,
              hasSubmittedAnswer: true,
              isAnswerCorrect: false,
              onSubmitAnswer: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Not quite right'), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('should submit when pressing Enter in the text field', (WidgetTester tester) async {
      var submitCalled = false;
      String? submittedReference;

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
              onSubmitAnswer: (ref) {
                submitCalled = true;
                submittedReference = ref;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Genesis 1:1');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submitCalled, isTrue);
      expect(submittedReference, equals('Genesis 1:1'));
    });
  });
}
