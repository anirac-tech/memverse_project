
import 'package:flutter_test/flutter_test.dart';

/// Usage: I see a circular progress indicator showing {50}%
Future<void> iSeeCircularProgressIndicatorShowingPercent(
    WidgetTester tester,
    int percent,
) async {
  await tester.pumpAndSettle();
  expect(find.text('$percent%'), findsOneWidget);
}
