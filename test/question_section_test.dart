import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/features/verse/presentation/widgets/question_section.dart';
import 'package:memverse/src/features/verse/presentation/widgets/verse_card.dart';
import 'package:memverse/src/features/verse/presentation/widgets/verse_reference_form.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late MockAppLocalizations mockL10n;
  late TextEditingController answerController;
  late FocusNode answerFocusNode;

  setUp(() {
    mockL10n = MockAppLocalizations();
    answerController = TextEditingController();
    answerFocusNode = FocusNode();

    when(() => mockL10n.question).thenReturn('Question');
    when(() => mockL10n.reference).thenReturn('Reference');
    when(() => mockL10n.enterReferenceHint).thenReturn('Enter Reference');
    when(() => mockL10n.referenceFormat).thenReturn('Format: Book Chapter:Verse');
    when(() => mockL10n.submit).thenReturn('Submit');
  });

  tearDown(() {
    answerController.dispose();
    answerFocusNode.dispose();
  });

  group('QuestionSection', () {
    final testVerses = [
      Verse(
        text: 'In the beginning God created the heavens and the earth.',
        reference: 'Genesis 1:1',
      ),
      Verse(
        text: 'For God so loved the world that he gave his one and only Son.',
        reference: 'John 3:16',
      ),
    ];

    testWidgets('renders question number correctly', (WidgetTester tester) async {
      // Arrange
      const questionNumber = 5;
      final versesAsync = AsyncValue.data(testVerses);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuestionSection(
                versesAsync: versesAsync,
                currentVerseIndex: 0,
                questionNumber: questionNumber,
                l10n: mockL10n,
                answerController: answerController,
                answerFocusNode: answerFocusNode,
                hasSubmittedAnswer: false,
                isAnswerCorrect: false,
                onSubmitAnswer: (_) {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Question: '), findsOneWidget);
      expect(find.text('$questionNumber'), findsOneWidget);
    });

    testWidgets('displays correct verse based on index', (WidgetTester tester) async {
      // Arrange
      final versesAsync = AsyncValue.data(testVerses);

      // Act - show the first verse
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuestionSection(
                versesAsync: versesAsync,
                currentVerseIndex: 0,
                questionNumber: 1,
                l10n: mockL10n,
                answerController: answerController,
                answerFocusNode: answerFocusNode,
                hasSubmittedAnswer: false,
                isAnswerCorrect: false,
                onSubmitAnswer: (_) {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('In the beginning God created the heavens and the earth.'), findsOneWidget);
      expect(find.text('Genesis 1:1'), findsOneWidget);
      expect(find.text('John 3:16'), findsNothing);

      // Act - show the second verse
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuestionSection(
                versesAsync: versesAsync,
                currentVerseIndex: 1,
                questionNumber: 2,
                l10n: mockL10n,
                answerController: answerController,
                answerFocusNode: answerFocusNode,
                hasSubmittedAnswer: false,
                isAnswerCorrect: false,
                onSubmitAnswer: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('For God so loved the world that he gave his one and only Son.'),
        findsOneWidget,
      );
      expect(find.text('John 3:16'), findsOneWidget);
      expect(find.text('Genesis 1:1'), findsNothing);
    });

    testWidgets('shows loading indicator when verses are loading', (WidgetTester tester) async {
      // Arrange
      const versesAsync = AsyncValue<List<Verse>>.loading();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuestionSection(
                versesAsync: versesAsync,
                currentVerseIndex: 0,
                questionNumber: 1,
                l10n: mockL10n,
                answerController: answerController,
                answerFocusNode: answerFocusNode,
                hasSubmittedAnswer: false,
                isAnswerCorrect: false,
                onSubmitAnswer: (_) {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(VerseCard), findsNothing);
      expect(find.byType(VerseReferenceForm), findsNothing);
    });

    testWidgets('shows error message when verses fail to load', (WidgetTester tester) async {
      // Arrange
      const error = 'Failed to load verses';
      const versesAsync = AsyncValue<List<Verse>>.error(error, StackTrace.empty);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuestionSection(
                versesAsync: versesAsync,
                currentVerseIndex: 0,
                questionNumber: 1,
                l10n: mockL10n,
                answerController: answerController,
                answerFocusNode: answerFocusNode,
                hasSubmittedAnswer: false,
                isAnswerCorrect: false,
                onSubmitAnswer: (_) {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Error loading verses: $error'), findsOneWidget);
      expect(find.byType(VerseCard), findsNothing);
      expect(find.byType(VerseReferenceForm), findsNothing);
    });

    testWidgets('calls onSubmitAnswer when form is submitted', (WidgetTester tester) async {
      // Arrange
      final versesAsync = AsyncValue.data(testVerses);
      String? submittedAnswer;
      void onSubmit(String answer) {
        submittedAnswer = answer;
      }

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuestionSection(
                versesAsync: versesAsync,
                currentVerseIndex: 0,
                questionNumber: 1,
                l10n: mockL10n,
                answerController: answerController,
                answerFocusNode: answerFocusNode,
                hasSubmittedAnswer: false,
                isAnswerCorrect: false,
                onSubmitAnswer: onSubmit,
              ),
            ),
          ),
        ),
      );

      // Enter text into the form
      await tester.enterText(find.byType(TextField), 'Genesis 1:1');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Assert
      expect(submittedAnswer, 'Genesis 1:1');
    });
  });
}
