import 'package:flutter_test/flutter_test.dart';

/// Usage: I see the text "1/1"
Future<void> iSeeTheExactText(WidgetTester tester, String text) async {
  await tester.pumpAndSettle();
  expect(find.text(text), findsOneWidget);
}