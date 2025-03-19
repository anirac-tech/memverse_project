import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders RefTestScreen', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(RefTestScreen), findsOneWidget);
    });
  });
}
