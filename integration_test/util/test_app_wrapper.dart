import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/auth/data/fake_user_repository.dart';
import 'package:memverse/src/features/auth/domain/user_repository.dart';

/// Provider for user repository in tests
final userRepositoryProvider = Provider<UserRepository>((ref) => FakeUserRepository());

/// A utility test app wrapper for widget tests.
class TestAppWrapper extends StatelessWidget {
  const TestAppWrapper({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [userRepositoryProvider.overrideWith((ref) => FakeUserRepository())],
      child: MaterialApp(
        home: child,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
      ),
    );
  }
}

/// Build a test app with the provided home widget (legacy/shortcut for convenience)
Widget buildTestApp({required Widget home}) {
  return TestAppWrapper(child: home);
}
