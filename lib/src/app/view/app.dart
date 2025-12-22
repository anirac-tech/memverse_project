import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/constants/themes.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/presentation/auth_wrapper.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/settings/presentation/theme_provider.dart';
import 'package:memverse/src/features/signed_in/presentation/signed_in_nav_scaffold.dart';
import 'package:talker_flutter/talker_flutter.dart';

late ProviderContainer container;

Talker get talker => container.read(talkerProvider);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return UncontrolledProviderScope(
      container: container,
      child: Builder(
        builder: (context) {
          final isDarkMode =
              themeMode == ThemeMode.dark ||
              (themeMode == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness == Brightness.dark);

          return BetterFeedback(
            theme: isDarkMode ? AppThemes.feedbackDarkTheme : AppThemes.feedbackTheme,
            child: TalkerWrapper(
              talker: container.read(talkerProvider),
              options: const TalkerWrapperOptions(enableErrorAlerts: true),
              child: MaterialApp(
                theme: AppThemes.light,
                darkTheme: AppThemes.dark,
                themeMode: themeMode,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: AuthService.isDummyUser ? const SignedInNavScaffold() : const AuthWrapper(),
              ),
            ),
          );
        },
      ),
    );
  }
}
