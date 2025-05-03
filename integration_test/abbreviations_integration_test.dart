import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Abbreviations Integration Test', () {
    testWidgets('App accepts Bible book abbreviations', (WidgetTester tester) async {
      // Launch the app
      app.main();

      // Wait for the app to load and API call to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify the first verse from the API is displayed
      expect(
        find.textContaining('He existed before anything else'),
        findsOneWidget,
        reason: 'API data should be displayed',
      );

      // Enter the valid abbreviation for the book
      await tester.enterText(find.byType(TextField), 'Col 1:17');

      // Submit the answer
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      // Verify the answer was accepted as correct
      expect(find.byType(SnackBar), findsOneWidget, reason: 'Feedback snackbar should appear');

      expect(
        find.textContaining('Correct'),
        findsOneWidget,
        reason: 'The abbreviation "Col 1:17" should be recognized as correct',
      );

      // Wait for the next verse to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify the second verse from the API is displayed
      expect(
        find.textContaining('For I can do everything through Christ'),
        findsOneWidget,
        reason: 'Second verse should be displayed after answering the first one',
      );

      // Enter the valid abbreviation for the second reference
      await tester.enterText(find.byType(TextField), 'Phil 4:13');

      // Submit the answer
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      // Verify the answer was accepted as correct
      expect(
        find.textContaining('Correct'),
        findsOneWidget,
        reason: 'The abbreviation "Phil 4:13" should be recognized as correct',
      );
    }, tags: ['integration']);
  });
}
