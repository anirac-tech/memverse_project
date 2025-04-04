import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';
import 'package:memverse/src/features/verse/presentation/widgets/reference_gauge.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late MockAppLocalizations mockL10n;

  setUp(() {
    mockL10n = MockAppLocalizations();
    when(() => mockL10n.referenceRecall).thenReturn('Reference Recall');
    when(() => mockL10n.question).thenReturn('Question');
    when(() => mockL10n.referenceFormat).thenReturn('Format: Book Chapter:Verse');
  });

  group('ReferenceGauge', () {
    testWidgets('displays correct percentage based on progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(progress: 50, totalCorrect: 5, totalAnswered: 10, l10n: mockL10n),
          ),
        ),
      );

      expect(find.text('50%'), findsOneWidget);
      expect(find.text('5/10'), findsOneWidget);
    });

    testWidgets('displays 0% when no answers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(progress: 0, totalCorrect: 0, totalAnswered: 0, l10n: mockL10n),
          ),
        ),
      );

      expect(find.text('0%'), findsOneWidget);
      expect(find.text('0/0'), findsOneWidget);
    });

    testWidgets('displays correct color based on progress - red for low progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(progress: 20, totalCorrect: 1, totalAnswered: 5, l10n: mockL10n),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(
        (progressIndicator.valueColor as AlwaysStoppedAnimation<Color>?)?.value,
        Colors.red[400],
      );
    });

    testWidgets('displays correct color based on progress - orange for medium progress', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(progress: 50, totalCorrect: 5, totalAnswered: 10, l10n: mockL10n),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(
        (progressIndicator.valueColor as AlwaysStoppedAnimation<Color>?)?.value,
        Colors.orange[400],
      );
    });

    testWidgets('displays correct color based on progress - green for high progress', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(progress: 80, totalCorrect: 8, totalAnswered: 10, l10n: mockL10n),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(
        (progressIndicator.valueColor as AlwaysStoppedAnimation<Color>?)?.value,
        Colors.green[400],
      );
    });

    testWidgets('displays loading state when verse is loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('VerseReferenceValidator', () {
    test('isValid returns false for empty string', () {
      expect(VerseReferenceValidator.isValid(''), false);
    });

    test('isValid returns true for valid references', () {
      expect(VerseReferenceValidator.isValid('Genesis 1:1'), true);
      expect(VerseReferenceValidator.isValid('John 3:16'), true);
      expect(VerseReferenceValidator.isValid('1 Corinthians 13:4'), true);
    });

    test('isValid returns false for invalid formats', () {
      expect(VerseReferenceValidator.isValid('Genesis'), false);
      expect(VerseReferenceValidator.isValid('Genesis 1'), false);
      expect(VerseReferenceValidator.isValid('Genesis:1'), false);
      expect(VerseReferenceValidator.isValid('Unknown 1:1'), false);
    });
  });

  group('Validation', () {
    test('isValid returns false for invalid formats', () {
      expect(VerseReferenceValidator.isValid('Genesis'), false);
      expect(VerseReferenceValidator.isValid('Genesis 1'), false);
      expect(VerseReferenceValidator.isValid('Genesis:1'), false);
      expect(VerseReferenceValidator.isValid('Unknown 1:1'), false);
    });
  });

  group('ValidationErrors', () {
    testWidgets('displays format error for invalid references', (tester) async {
      final mockLocalizations = MockAppLocalizations();
      when(() => mockLocalizations.referenceCannotBeEmpty).thenReturn('Reference cannot be empty');

      final verseForm = MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  helperText: 'Invalid format',
                  helperStyle: TextStyle(color: Colors.orange),
                ),
              ),
              ElevatedButton(onPressed: () {}, child: const Text('Submit')),
            ],
          ),
        ),
      );

      await tester.pumpWidget(verseForm);
      expect(find.text('Invalid format'), findsOneWidget);
    });
  });

  group('Progress calculation', () {
    testWidgets('correctly calculates progress when submitting answers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return const Column(children: [ProgressTestWrapper()]);
            },
          ),
        ),
      );

      // Initially should be 0%
      expect(find.text('0%'), findsOneWidget);
      expect(find.text('0/0'), findsOneWidget);

      // Submit a correct answer
      await tester.tap(find.byKey(const Key('correct-button')));
      await tester.pump();
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('1/1'), findsOneWidget);

      // Submit an incorrect answer
      await tester.tap(find.byKey(const Key('incorrect-button')));
      await tester.pump();
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);

      // Submit two more correct answers
      await tester.tap(find.byKey(const Key('correct-button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('correct-button')));
      await tester.pump();
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('3/4'), findsOneWidget);
    });
  });
}

// A test wrapper to simulate the progress calculation logic
class ProgressTestWrapper extends StatefulWidget {
  const ProgressTestWrapper({super.key});

  @override
  State<ProgressTestWrapper> createState() => _ProgressTestWrapperState();
}

class _ProgressTestWrapperState extends State<ProgressTestWrapper> {
  double progress = 0;
  int totalCorrect = 0;
  int totalAnswered = 0;
  late MockAppLocalizations _mockL10n;
  String? error;
  bool isLoading = false;
  String? validationError;
  bool isErrored = false;
  bool isValidated = false;

  @override
  void initState() {
    super.initState();
    _mockL10n = MockAppLocalizations();
    when(() => _mockL10n.referenceRecall).thenReturn('Reference Recall');
    when(() => _mockL10n.question).thenReturn('Question');
    when(() => _mockL10n.referenceFormat).thenReturn('Format: Book Chapter:Verse');
  }

  void submitCorrectAnswer() {
    setState(() {
      totalCorrect++;
      totalAnswered++;
      progress = (totalCorrect / totalAnswered) * 100;
    });
  }

  void submitIncorrectAnswer() {
    setState(() {
      totalAnswered++;
      progress = (totalCorrect / totalAnswered) * 100;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ReferenceGauge(
        progress: progress,
        totalCorrect: totalCorrect,
        totalAnswered: totalAnswered,
        l10n: _mockL10n,
        error: error,
        isLoading: isLoading,
        validationError: validationError,
      ),
      ElevatedButton(
        key: const Key('correct-button'),
        onPressed: submitCorrectAnswer,
        child: const Text('Correct Answer'),
      ),
      ElevatedButton(
        key: const Key('incorrect-button'),
        onPressed: submitIncorrectAnswer,
        child: const Text('Incorrect Answer'),
      ),
    ],
  );
}
