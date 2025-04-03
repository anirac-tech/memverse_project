import 'package:flutter/material.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const MemversePage(),
  );
}
