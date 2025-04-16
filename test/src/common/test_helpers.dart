import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock class for AppLocalizations
class MockAppLocalizations extends Mock {
  static const delegate = _MockLocalizationsDelegate();
  static const List<Locale> supportedLocales = [Locale('en')];

  // Add mock methods for any localized strings used in tests
  String get username => 'Username';

  String get password => 'Password';

  String get login => 'Login';

  String get pleaseEnterYourUsername => 'Please enter your username';

  String get pleaseEnterYourPassword => 'Please enter your password';

  String get showPassword => 'Show password';

  String get hidePassword => 'Hide password';

  String get referenceTest => 'Reference Test';

  String get referenceCannotBeEmpty => 'Reference cannot be empty';

  String correctReferenceIdentification(String reference) => 'Correct! $reference';

  String notQuiteRight(String reference) => 'Not quite right. Correct reference: $reference';
}

/// Mock delegate for AppLocalizations
class _MockLocalizationsDelegate extends LocalizationsDelegate<dynamic> {
  const _MockLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<dynamic> load(Locale locale) async => MockAppLocalizations();

  @override
  bool shouldReload(_MockLocalizationsDelegate old) => false;
}
