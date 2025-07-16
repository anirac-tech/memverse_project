import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/constants/themes.dart';

class FeedbackLogoutActions extends ConsumerWidget {
  const FeedbackLogoutActions({super.key, this.onLogout});
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
    children: [
      IconButton(
        key: const Key('feedback_button'),
        icon: Icon(
          Icons.feedback_outlined,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : mvLightGreen,
        ),
        tooltip: 'Feedback',
        onPressed: () => BetterFeedback.of(context).show((feedback) async {
          ScaffoldMessenger.maybeOf(
            context,
          )?.showSnackBar(const SnackBar(content: Text('Thanks for your feedback!')));
          await ref
              .read(analyticsServiceProvider)
              .track(
                'feedback_submitted',
                properties: {'text': feedback.text, 'with_screenshot': feedback.screenshot != null},
              );
        }),
      ),
      IconButton(
        icon: Icon(
          Icons.logout,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : mvLightGreen,
        ),
        tooltip: 'Logout',
        onPressed: onLogout ?? () => Navigator.of(context).maybePop(),
      ),
    ],
  );
}
