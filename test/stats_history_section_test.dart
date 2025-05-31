import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/presentation/widgets/stats_and_history_section.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late MockAppLocalizations mockL10n;

  setUp(() {
    mockL10n = MockAppLocalizations();
    when(() => mockL10n.referencesDueToday).thenReturn('References Due Today');
    when(() => mockL10n.priorQuestions).thenReturn('Prior Questions');
    when(() => mockL10n.noPreviousQuestions).thenReturn('No previous questions');
  });

  group('StatsAndHistorySection', () {
    testWidgets('displays all components correctly with default values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatsAndHistorySection(l10n: mockL10n, pastQuestions: const []),
          ),
        ),
      );

      // Check for no previous questions message
      expect(find.text('No previous questions'), findsOneWidget);
    });

    testWidgets('displays past questions when available', (WidgetTester tester) async {
      const pastQuestions = [
        'Genesis 1:1-[Genesis 1:1] Correct!',
        'John 3:16-[John 3:16] Correct!',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: StatsAndHistorySection(l10n: mockL10n, pastQuestions: pastQuestions),
          ),
        ),
      );

      // Check for the past questions
      expect(find.text('Genesis 1:1-[Genesis 1:1] Correct!'), findsOneWidget);
      expect(find.text('John 3:16-[John 3:16] Correct!'), findsOneWidget);

      // Should not show "No previous questions" when there are questions
      expect(find.text('No previous questions'), findsNothing);
    });
  });
}
