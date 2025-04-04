import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';
import 'package:memverse/src/features/verse/presentation/widgets/question_section.dart';
import 'package:memverse/src/features/verse/presentation/widgets/reference_gauge.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

class MockVerseRepository extends Mock implements FakeVerseRepository {}

void main() {
  group('QuestionSection', () {
    late MockAppLocalizations mockL10n;
    late TextEditingController answerController;
    late FocusNode answerFocusNode;

    setUp(() {
      mockL10n = MockAppLocalizations();
      answerController = TextEditingController();
      answerFocusNode = FocusNode();

      when(() => mockL10n.question).thenReturn('Question');
      when(() => mockL10n.reference).thenReturn('Reference');
      when(() => mockL10n.enterReferenceHint).thenReturn('Enter verse reference');
      when(() => mockL10n.referenceFormat).thenReturn('Format: Book Chapter:Verse');
      when(() => mockL10n.submit).thenReturn('Submit');
    });

    tearDown(() {
      answerController.dispose();
      answerFocusNode.dispose();
    });

    testWidgets('shows loading indicator when verses are loading', (WidgetTester tester) async {
      const asyncValue = AsyncValue<List<Verse>>.loading();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: QuestionSection(
              versesAsync: asyncValue,
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
      );

      // Looking for the RichText that contains Question: 1
      expect(find.byType(RichText), findsAtLeastNWidgets(1));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when verse loading fails', (WidgetTester tester) async {
      const asyncValue = AsyncValue<List<Verse>>.error('Failed to load verses', StackTrace.empty);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: QuestionSection(
              versesAsync: asyncValue,
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
      );

      // Looking for the RichText that contains Question: 1
      expect(find.byType(RichText), findsAtLeastNWidgets(1));
      expect(find.text('Error loading verses: Failed to load verses'), findsOneWidget);
    });
  });

  group('MemversePage', () {
    late ProviderContainer container;
    late MockVerseRepository mockRepository;
    late MockAppLocalizations mockL10n;

    setUp(() {
      mockRepository = MockVerseRepository();
      mockL10n = MockAppLocalizations();

      // Setup mock repository
      when(
        () => mockRepository.getVerses(),
      ).thenAnswer((_) async => [Verse(text: 'Test verse text', reference: 'Test 1:1')]);

      // Setup localizations
      when(() => mockL10n.referenceTest).thenReturn('Reference Test');
      when(() => mockL10n.question).thenReturn('Question');
      when(() => mockL10n.reference).thenReturn('Reference');
      when(() => mockL10n.submit).thenReturn('Submit');
      when(() => mockL10n.referenceFormat).thenReturn('Format: Book Chapter:Verse');
      when(() => mockL10n.enterReferenceHint).thenReturn('Enter reference');
      when(() => mockL10n.referenceRecall).thenReturn('Reference Recall');
      when(() => mockL10n.referencesDueToday).thenReturn('References Due Today');
      when(() => mockL10n.priorQuestions).thenReturn('Prior Questions');
      when(() => mockL10n.noPreviousQuestions).thenReturn('No previous questions');
      when(() => mockL10n.referenceCannotBeEmpty).thenReturn('Reference cannot be empty');
      when(() => mockL10n.notQuiteRight(any())).thenReturn('Not quite right');

      // Override the provider for testing
      container = ProviderContainer(
        overrides: [verseListProvider.overrideWith((_) => mockRepository.getVerses())],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders correctly with initial state', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MemversePage(),
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );

      // Initial loading state - find at least one progress indicator
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));

      // Allow async operations to complete
      await tester.pumpAndSettle();

      // After loading
      expect(find.byType(RichText), findsAtLeastNWidgets(1)); // At least one RichText widget
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ReferenceGauge), findsOneWidget);
    });

    testWidgets('shows snackbar for empty reference submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MemversePage(),
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Submit empty reference
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check that snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
