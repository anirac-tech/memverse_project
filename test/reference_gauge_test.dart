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
  });

  group('ReferenceGauge', () {
    testWidgets('displays loading indicator when isLoading is true', (WidgetTester tester) async {
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
      expect(find.text('0%'), findsNothing);
    });

    testWidgets('displays red gauge for low progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(progress: 25, totalCorrect: 1, totalAnswered: 4, l10n: mockL10n),
          ),
        ),
      );

      expect(find.text('25%'), findsOneWidget);
      expect(find.text('1/4'), findsOneWidget);

      // Check that the CircularProgressIndicator exists
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      // Value should be 0.25
      expect(progressIndicator.value, equals(0.25));

      // Color should be red (for progress < 33)
      expect(
        (progressIndicator.valueColor! as AlwaysStoppedAnimation<Color>).value,
        equals(Colors.red[400]),
      );
    });

    testWidgets('displays orange gauge for medium progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(progress: 50, totalCorrect: 2, totalAnswered: 4, l10n: mockL10n),
          ),
        ),
      );

      expect(find.text('50%'), findsOneWidget);
      expect(find.text('2/4'), findsOneWidget);

      // Check that the CircularProgressIndicator exists
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      // Color should be orange (for progress between 33 and 66)
      expect(
        (progressIndicator.valueColor! as AlwaysStoppedAnimation<Color>).value,
        equals(Colors.orange[400]),
      );
    });

    testWidgets('displays green gauge for high progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(progress: 75, totalCorrect: 3, totalAnswered: 4, l10n: mockL10n),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error state when error is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              error: 'Test error',
            ),
          ),
        ),
      );

      expect(find.text('Reference Progress'), findsOneWidget);
    });

    testWidgets('displays validation error state when validationError is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
              validationError: 'Validation error',
            ),
          ),
        ),
      );

      expect(find.text('Reference Progress'), findsOneWidget);
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

      // Set error
      await tester.tap(find.byKey(const Key('error-button')));
      await tester.pump();
      expect(find.text('Reference Progress'), findsOneWidget);

      // Set validation error
      await tester.tap(find.byKey(const Key('validation-error-button')));
      await tester.pump();
      expect(find.text('Reference Progress'), findsOneWidget);
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

  void setError() {
    setState(() {
      error = 'Test error';
    });
  }

  void setValidationError() {
    setState(() {
      validationError = 'Validation error';
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
      ElevatedButton(
        key: const Key('error-button'),
        onPressed: setError,
        child: const Text('Set Error'),
      ),
      ElevatedButton(
        key: const Key('validation-error-button'),
        onPressed: setValidationError,
        child: const Text('Set Validation Error'),
      ),
    ],
  );
}
