import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/app/view/app.dart';

Future<void> theAppIsRunning(WidgetTester tester) async {
  await tester.pumpWidget(const App());
}
