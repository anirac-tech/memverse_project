import 'package:flutter_test/flutter_test.dart';

/// Usage: I see verse text
Future<void> iSeeVerseText(WidgetTester tester) async {
  // Wait for the page to load
  await tester.pumpAndSettle();

  // Look for verse text - this should be in a VerseCard widget
  // Since we don't know the exact verse text, we'll look for common verse indicators
  final verseTextElements = [
    find.textContaining('He is before all things'),
    find.textContaining('before all things'),
    find.textContaining('Colossians'),
    find.textContaining('1:17'),
  ];

  // Verify at least one verse text element is present
  var verseTextFound = false;
  for (final element in verseTextElements) {
    if (element.evaluate().isNotEmpty) {
      verseTextFound = true;
      break;
    }
  }

  expect(verseTextFound, isTrue, reason: 'Verse text should be visible');
}
