import 'package:flutter_test/flutter_test.dart';

/// Usage: I don't see text containing {'Genesis 1:1'}
Future<void> iDontSeeTextContaining(WidgetTester tester, String text) async {
  expect(find.textContaining(text), findsNothing);
}
