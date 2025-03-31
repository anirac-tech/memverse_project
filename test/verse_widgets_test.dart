import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('VerseCard', () {
    testWidgets('should display verse text and translation', (WidgetTester tester) async {
      const verseText = 'In the beginning God created the heavens and the earth.';
      const verseReference = 'Genesis 1:1';
      const verseTranslation = 'NLT';

      final verse = Verse(text: verseText, reference: verseReference);

      await tester.pumpWidget(MaterialApp(home: Material(child: VerseCard(verse: verse))));

      expect(find.text(verseText), findsOneWidget);
      expect(find.text(verseTranslation), findsOneWidget);
      expect(find.byKey(const Key('refTestVerse')), findsOneWidget);
    });
  });

  group('QuestionHistoryWidget', () {
    late MockAppLocalizations mockL10n;

    setUp(() {
      mockL10n = MockAppLocalizations();
      when(() => mockL10n.priorQuestions).thenReturn('Prior Questions');
      when(() => mockL10n.noPreviousQuestions).thenReturn('No previous questions');
    });

    testWidgets('should show no questions message when empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: QuestionHistoryWidget(pastQuestions: const [], l10n: mockL10n)),
        ),
      );

      expect(find.text('Prior Questions'), findsOneWidget);
      expect(find.text('No previous questions'), findsOneWidget);
      expect(find.byKey(const Key('past-questions')), findsOneWidget);
    });

    testWidgets('should display past questions', (WidgetTester tester) async {
      final pastQuestions = [
        'Genesis 1:1-[Genesis 1:1] Correct!',
        'John 3:17-[John 3:16] Incorrect',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: mockL10n),
          ),
        ),
      );

      expect(find.text('Prior Questions'), findsOneWidget);
      expect(find.text('Genesis 1:1-[Genesis 1:1] Correct!'), findsOneWidget);
      expect(find.text('John 3:17-[John 3:16] Incorrect'), findsOneWidget);

      // The last item should be bold (latest question)
      final lastQuestionText = tester.widget<Text>(find.text('John 3:17-[John 3:16] Incorrect'));
      expect(lastQuestionText.style?.fontWeight, equals(FontWeight.bold));
    });
  });
}
