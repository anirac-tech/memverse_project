import 'package:flutter_test/flutter_test.dart';

/// Usage: I wait {3} seconds
Future<void> iWaitSeconds(WidgetTester tester, int seconds) async {
  await tester.pumpAndSettle(Duration(seconds: seconds));
}
