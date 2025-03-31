import 'package:flutter_test/flutter_test.dart';

/// Usage: I don't see text "Error message"
Future<void> iDontSeeText(WidgetTester tester, String text) async {
  await tester.pumpAndSettle();
  expect(find.text(text), findsNothing);
}