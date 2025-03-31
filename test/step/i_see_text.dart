import 'package:flutter_test/flutter_test.dart';

/// Usage: I see text "Hello"
Future<void> iSeeText(WidgetTester tester, String text) async {
  await tester.pumpAndSettle();
  expect(find.text(text), findsOneWidget);
}