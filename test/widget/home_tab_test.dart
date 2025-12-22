import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/home/home_tab.dart';

void main() {
  testWidgets('Tapping feedback button shows feedback overlay', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BetterFeedback(
          child: HomeTab(),
          // To really verify palette, could set drawColors/activeColor here; this will use defaults set globally.
        ),
      ),
    );

    // Feedback should not be visible initially
    expect(find.text("What's wrong?"), findsNothing);

    // Tap the feedback button
    await tester.tap(find.byKey(const Key('feedback_button')));
    await tester.pumpAndSettle();

    // Verify feedback overlay opens
    expect(find.text("What's wrong?"), findsOneWidget);
  });
}
