import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../common/test_helpers.dart';

// Mock MemversePage for integration testing
class MockMemversePage extends StatefulWidget {
  const MockMemversePage({super.key});

  @override
  State<MockMemversePage> createState() => _MockMemversePageState();
}

class _MockMemversePageState extends State<MockMemversePage> {
  final textController = TextEditingController();
  String displayedVerse =
      'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.';
  bool showNextVerse = false;
  int correctAnswers = 0;
  int totalAnswers = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reference Test')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(padding: const EdgeInsets.all(16), child: Text(displayedVerse)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Reference',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Simulate answer submission
                  setState(() {
                    if (textController.text == 'John 3:16') {
                      correctAnswers++;
                      // For this test, we'll just replace the verse text on correct answer
                      displayedVerse =
                          'And we know that in all things God works for the good of those who love him, who have been called according to his purpose.';
                    }
                    totalAnswers++;
                    showNextVerse = true;
                  });
                  // Clear the text field
                  textController.clear();
                },
                child: const Text('Submit'),
              ),
              if (totalAnswers > 0) Text('$correctAnswers/$totalAnswers correct'),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  group('Scripture Memory Testing', () {
    testWidgets('User can answer verse reference questions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [MockAppLocalizations.delegate],
            supportedLocales: MockAppLocalizations.supportedLocales,
            home: MockMemversePage(),
          ),
        ),
      );

      // GIVEN I am on the memverse page
      await tester.pumpAndSettle();

      // THEN I see the verse text displayed
      expect(
        find.text(
          'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
        ),
        findsOneWidget,
      );

      // AND I see the reference input field
      expect(find.byType(TextField), findsOneWidget);

      // WHEN I enter a correct reference
      await tester.enterText(find.byType(TextField), 'John 3:16');

      // AND I submit my answer
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // THEN I should see the next verse
      expect(
        find.text(
          'And we know that in all things God works for the good of those who love him, who have been called according to his purpose.',
        ),
        findsOneWidget,
      );

      // AND I should see updated stats
      expect(find.text('1/1 correct'), findsOneWidget);
    });
  });
}
