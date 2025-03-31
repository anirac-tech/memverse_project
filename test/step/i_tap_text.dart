import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap text "Button"
Future<void> iTapText(WidgetTester tester, String text) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}