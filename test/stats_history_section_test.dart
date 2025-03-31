import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('StatsAndHistorySection', () {
    late MockAppLocalizations mockL10n;

    setUp(() {
      mockL10n = MockAppLocalizations();
      when(() => mockL10n.referencesDueToday).thenReturn('References Due Today');
      when(() => mockL10n.priorQuestions).thenReturn('Prior Questions');
      when(() => mockL10n.noPreviousQuestions).thenReturn('No previous questions');
    });

    testWidgets('should display stats and empty history', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatsAndHistorySection(
              progress: 75,
              totalCorrect: 3,
              totalAnswered: 4,
              l10n: mockL10n,
              overdueReferences: 5,
              pastQuestions: const [],
            ),
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
      expect(find.text('3/4'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('References Due Today'), findsOneWidget);
      expect(find.text('Prior Questions'), findsOneWidget);
      expect(find.text('No previous questions'), findsOneWidget);
    });

    testWidgets('should display history items', (WidgetTester tester) async {
      final pastQuestions = [
        'Genesis 1:1-[Genesis 1:1] Correct!',
        'John 3:17-[John 3:16] Incorrect',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatsAndHistorySection(
              progress: 50,
              totalCorrect: 1,
              totalAnswered: 2,
              l10n: mockL10n,
              overdueReferences: 3,
              pastQuestions: pastQuestions,
            ),
          ),
        ),
      );

      expect(find.text('50%'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Genesis 1:1-[Genesis 1:1] Correct!'), findsOneWidget);
      expect(find.text('John 3:17-[John 3:16] Incorrect'), findsOneWidget);
    });

    testWidgets('should display error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatsAndHistorySection(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              overdueReferences: 5,
              pastQuestions: const [],
              isErrored: true,
              error: 'Error loading verses',
            ),
          ),
        ),
      );

      // ReferenceGauge should display error instead of progress
      expect(find.text('Error loading verses'), findsOneWidget);
      expect(find.text('0%'), findsNothing);
    });

    testWidgets('should display loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatsAndHistorySection(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              overdueReferences: 5,
              pastQuestions: const [],
              isLoading: true,
            ),
          ),
        ),
      );

      // ReferenceGauge should display loading indicator
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
      expect(find.text('0%'), findsNothing);
    });

    testWidgets('should display validation error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatsAndHistorySection(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              overdueReferences: 5,
              pastQuestions: const [],
              isValidated: true,
              validationError: 'Invalid reference format',
            ),
          ),
        ),
      );

      // ReferenceGauge should display validation error
      expect(find.text('Invalid reference format'), findsOneWidget);
      expect(find.text('0%'), findsNothing);
    });
  });
}
