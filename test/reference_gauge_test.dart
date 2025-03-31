import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late MockAppLocalizations mockL10n;

  setUp(() {
    mockL10n = MockAppLocalizations();
    when(() => mockL10n.referenceRecall).thenReturn('Reference Recall');
  });

  group('ReferenceGauge', () {
    testWidgets('displays correct percentage based on progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(
              progress: 50,
              totalCorrect: 5,
              totalAnswered: 10,
              l10n: mockL10n,
            ),
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
            body: ReferenceGauge(
              progress: 0,
              totalCorrect: 0,
              totalAnswered: 0,
              l10n: mockL10n,
            ),
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
            body: ReferenceGauge(
              progress: 20,
              totalCorrect: 1,
              totalAnswered: 5,
              l10n: mockL10n,
            ),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      
      expect(
        (progressIndicator.valueColor as AlwaysStoppedAnimation<Color>).value,
        Colors.red[400],
      );
    });

    testWidgets('displays correct color based on progress - orange for medium progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(
              progress: 50,
              totalCorrect: 5,
              totalAnswered: 10,
              l10n: mockL10n,
            ),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      
      expect(
        (progressIndicator.valueColor as AlwaysStoppedAnimation<Color>).value,
        Colors.orange[400],
      );
    });

    testWidgets('displays correct color based on progress - green for high progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferenceGauge(
              progress: 80,
              totalCorrect: 8,
              totalAnswered: 10,
              l10n: mockL10n,
            ),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      
      expect(
        (progressIndicator.valueColor as AlwaysStoppedAnimation<Color>).value,
        Colors.green[400],
      );
    });
  });

  group('Progress calculation', () {
    testWidgets('correctly calculates progress when submitting answers', 
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Column(
                children: [
                  ProgressTestWrapper(),
                ],
              );
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
  const ProgressTestWrapper({Key? key}) : super(key: key);

  @override
  State<ProgressTestWrapper> createState() => _ProgressTestWrapperState();
}

class _ProgressTestWrapperState extends State<ProgressTestWrapper> {
  double progress = 0;
  int totalCorrect = 0;
  int totalAnswered = 0;

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReferenceGauge(
          progress: progress,
          totalCorrect: totalCorrect,
          totalAnswered: totalAnswered,
          l10n: MockAppLocalizations(),
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
}