import 'package:flutter_test/flutter_test.dart';

/// Usage: I see text containing {'Error loading verses'}
Future<void> iSeeTextContaining(WidgetTester tester, String text) async {
  expect(find.textContaining(text), findsAtLeastNWidgets(1));
}