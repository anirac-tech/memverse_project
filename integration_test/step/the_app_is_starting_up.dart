import 'package:flutter_test/flutter_test.dart';

/// Usage: the app is starting up
Future<void> theAppIsStartingUp(WidgetTester tester) async {
  // Simulate the app starting up by triggering a rebuild without settling
  // This helps test loading states that might appear during app initialization
  await tester.pump();

  // Add a small delay to simulate startup time
  await tester.pump(const Duration(milliseconds: 100));
}
