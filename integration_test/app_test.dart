import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Verify API data is displayed correctly', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify that we see the expected API content (from the gist)
      expect(
        find.textContaining('He existed before anything else'),
        findsOneWidget,
        reason: 'API data from Gist should be displayed',
      );

      // Test answering with correct reference
      await tester.enterText(find.byType(TextField), 'Col 1:17');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      // Verify snackbar appears with correct message
      expect(
        find.byType(SnackBar),
        findsOneWidget,
        reason: 'Snackbar should appear after submission',
      );
      expect(
        find.textContaining('Correct'),
        findsOneWidget,
        reason: 'Should show correct feedback for API reference',
      );

      // Wait for the next verse to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify second verse appears
      expect(
        find.textContaining('For I can do everything through Christ'),
        findsOneWidget,
        reason: 'Second API verse should be displayed after answering first',
      );
    });
  });
}
