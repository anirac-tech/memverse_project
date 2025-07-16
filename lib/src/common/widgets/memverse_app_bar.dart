import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/constants/themes.dart';

/// A reusable, branded AppBar for Memverse screens.
/// - Shows 'Memverse' as the main title and accepts a [suffix] such as 'Ref', 'Verse', etc.
/// - [backgroundColor], [leading], and [actions] are customizable for consistency across screens.
/// - Use for all main/home/ref/settings tabs for visual consistency.
class MemverseAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MemverseAppBar({
    required this.suffix,
    super.key,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.brightness = Brightness.light,
    this.centerTitle = false,
  });

  final String suffix; // E.g. 'Ref', 'Verse', etc.
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Brightness brightness;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor =
        backgroundColor ??
        theme.appBarTheme.backgroundColor ??
        (isDark ? mvDarkNavBg : mvLightNavBg);
    final iconAndTitleColor =
        theme.appBarTheme.iconTheme?.color ?? (isDark ? Colors.white : mvLightGreen);
    final feedbackActions = <Widget>[
      IconButton(
        key: const Key('feedback_button'),
        icon: Icon(Icons.feedback_outlined, color: iconAndTitleColor),
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
        icon: Icon(Icons.logout, color: iconAndTitleColor),
        tooltip: 'Logout',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    ];
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      iconTheme: IconThemeData(color: iconAndTitleColor),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions ?? feedbackActions,
      title: RichText(
        text: TextSpan(
          style: theme.textTheme.headlineMedium?.copyWith(
            color: iconAndTitleColor,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          children: [
            const TextSpan(
              text: 'Mem',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const TextSpan(
              text: 'verse',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            if (suffix.trim().toLowerCase().startsWith('ref'))
              TextSpan(
                text: ' (Reference Quiz)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: iconAndTitleColor,
                  letterSpacing: 0.5,
                ),
              )
            else if (suffix.trim().toLowerCase().startsWith('verse'))
              TextSpan(
                text: ' (Verse Quiz)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: iconAndTitleColor,
                  letterSpacing: 0.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
