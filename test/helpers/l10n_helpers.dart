import 'package:flutter/material.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockL10n extends Mock implements AppLocalizations {}

// Global mock variable - will be set in setUp
MockL10n? _mockL10n;

class L10nTestHelper {
  static void setUp(MockL10n mockL10n) {
    _mockL10n = mockL10n;

    // Set up basic localization mocks
    when(() => mockL10n.username).thenReturn('Username');
    when(() => mockL10n.password).thenReturn('Password');
    when(() => mockL10n.login).thenReturn('Login');
    when(() => mockL10n.pleaseEnterYourUsername).thenReturn('Please enter your username');
    when(() => mockL10n.pleaseEnterYourPassword).thenReturn('Please enter your password');
    when(() => mockL10n.hidePassword).thenReturn('Hide password');
    when(() => mockL10n.showPassword).thenReturn('Show password');
    when(() => mockL10n.correct).thenReturn('Correct');
    when(() => mockL10n.notQuiteRight(any())).thenReturn('Not quite right');
    when(() => mockL10n.referenceFormat).thenReturn('Format: Book Ch:Verse');
    when(() => mockL10n.enterReferenceHint).thenReturn('Enter reference');
    when(() => mockL10n.submit).thenReturn('Submit');
    when(() => mockL10n.referenceRecall).thenReturn('Reference Recall');
    when(() => mockL10n.referenceCannotBeEmpty).thenReturn('Reference cannot be empty');
  }

  static void tearDown() {
    _mockL10n = null;
  }
}

// Widget to provide mock localizations in tests
class LocalizationWrapper extends StatelessWidget {
  const LocalizationWrapper({required this.child, required this.mockL10n, super.key});

  final Widget child;
  final AppLocalizations mockL10n;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [_MockLocalizationDelegate()],
      home: child,
    );
  }
}

class _MockLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _MockLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async => _mockL10n!;

  @override
  bool shouldReload(_MockLocalizationDelegate old) => false;
}
