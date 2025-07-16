import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/constants/themes.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/presentation/auth_wrapper.dart';
import 'package:memverse/src/features/signed_in/presentation/signed_in_nav_scaffold.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => ProviderScope(
    // Builder widget is needed here to access the MediaQuery and subsequently the platformBrightness
    // from the context provided by the MaterialApp widget that is a child of BetterFeedback.
    // Without the Builder, the MediaQuery.of(context) would use the context from above ProviderScope,
    // which doesn't have the necessary information.
    child: Builder(
      builder: (context) => BetterFeedback(
        theme: forceLightMode
            ? AppThemes.feedbackTheme
            : (MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? AppThemes.feedbackDarkTheme
                  : AppThemes.feedbackTheme),
        child: MaterialApp(
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: forceLightMode ? ThemeMode.light : ThemeMode.system,
          // Set forceLightMode=false in themes.dart to re-enable true dark mode when ready
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AuthService.isDummyUser ? const SignedInNavScaffold() : const AuthWrapper(),
        ),
      ),
    ),
  );
}
