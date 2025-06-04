import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/main_development.dart' as app;

Future<void> theAppIsRunning(WidgetTester tester) async {
  await app.main();
  await tester.pumpAndSettle();
}
