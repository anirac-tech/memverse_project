import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/common/widgets/memverse_app_bar.dart';

void main() {
  testWidgets(
      'MemverseAppBar feedback button triggers BetterFeedback and snackbar',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: BetterFeedback(
                child: Scaffold(appBar: MemverseAppBar(suffix: 'Test')),
            ),
          ),
        ),
      );

      // Tap feedback button
      await tester.tap(find.byKey(const Key('feedback_button')));
      await tester.pumpAndSettle();

      // Feedback overlay appears
      expect(find.text("What's wrong?"), findsOneWidget);
      // Simulate dismissing overlay
      final close = find
          .byTooltip('Cancel')
          .evaluate()
          .isNotEmpty
          ? find.byTooltip('Cancel')
          : find.byTooltip('Close');
        if (close
            .evaluate()
            .isNotEmpty) {
        await tester.tap(close);
        await tester.pumpAndSettle();
      } else {
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      }
    }
    // Confirm snackbar was shown
    expect(find.text('Thanks for your feedback!'), findsOneWidget);
  });
}
