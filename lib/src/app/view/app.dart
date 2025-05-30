import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/auth/presentation/auth_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => ProviderScope(
    child: BetterFeedback(
      theme: FeedbackThemeData(
        background: Colors.black.withAlpha(153),
        feedbackSheetColor: Colors.white,
        drawColors: [Colors.blue, Colors.red, Colors.green, Colors.yellow],
      ),
      child: MaterialApp(
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AuthWrapper(),
      ),
    ),
  );
}
