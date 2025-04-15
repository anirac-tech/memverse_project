import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/presentation/widgets/reference_gauge.dart';
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
            body: StatsAndHistorySection(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              overdueReferences: 5,
              pastQuestions: const [],
            ),
          ),
        ),
      );

      // Check for ReferenceGauge
      expect(find.byType(ReferenceGauge), findsOneWidget);

      // Check for overdue references section
      expect(find.text('5'), findsOneWidget);
      expect(find.text('References Due Today'), findsOneWidget);

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
            child: StatsAndHistorySection(
              progress: 100,
              totalCorrect: 2,
              totalAnswered: 2,
              l10n: mockL10n,
              overdueReferences: 3,
              pastQuestions: pastQuestions,
            ),
          ),
        ),
      );

      // Check for the past questions
      expect(find.text('Genesis 1:1-[Genesis 1:1] Correct!'), findsOneWidget);
      expect(find.text('John 3:16-[John 3:16] Correct!'), findsOneWidget);

      // Should not show "No previous questions" when there are questions
      expect(find.text('No previous questions'), findsNothing);
    });

    testWidgets('displays progress in ReferenceGauge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatsAndHistorySection(
              progress: 75,
              totalCorrect: 3,
              totalAnswered: 4,
              l10n: mockL10n,
              overdueReferences: 2,
              pastQuestions: const [],
            ),
          ),
        ),
      );

      final referenceGauge = tester.widget<ReferenceGauge>(find.byType(ReferenceGauge));

      expect(referenceGauge.progress, equals(75));
      expect(referenceGauge.totalCorrect, equals(3));
      expect(referenceGauge.totalAnswered, equals(4));
    });

    testWidgets('handles error state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatsAndHistorySection(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              overdueReferences: 0,
              pastQuestions: const [],
              hasError: true,
              error: 'Test error message',
            ),
          ),
        ),
      );

      // Error should be passed to the ReferenceGauge
      final referenceGauge = tester.widget<ReferenceGauge>(find.byType(ReferenceGauge));
      expect(referenceGauge.error, equals('Test error message'));
    });

    testWidgets('handles validation error state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatsAndHistorySection(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              overdueReferences: 0,
              pastQuestions: const [],
              isValidated: true,
              validationError: 'Validation error',
            ),
          ),
        ),
      );

      // Validation error should be passed to the ReferenceGauge
      final referenceGauge = tester.widget<ReferenceGauge>(find.byType(ReferenceGauge));
      expect(referenceGauge.validationError, equals('Validation error'));
    });

    testWidgets('handles loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatsAndHistorySection(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              overdueReferences: 0,
              pastQuestions: const [],
              isLoading: true,
            ),
          ),
        ),
      );

      // Loading state should be passed to the ReferenceGauge
      final referenceGauge = tester.widget<ReferenceGauge>(find.byType(ReferenceGauge));
      expect(referenceGauge.isLoading, isTrue);
    });
  });
}
