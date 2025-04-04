import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('es')];

  /// Title of app
  ///
  /// In en, this message translates to:
  /// **'Memverse'**
  String get appTitle;

  /// Text shown in the AppBar of the Reference Test Page
  ///
  /// In en, this message translates to:
  /// **'Reference Test'**
  String get referenceTestAppBarTitle;

  /// No description provided for @referenceTest.
  ///
  /// In en, this message translates to:
  /// **'Reference Test'**
  String get referenceTest;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference:'**
  String get reference;

  /// No description provided for @enterReferenceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter reference (e.g., Genesis 1:1)'**
  String get enterReferenceHint;

  /// No description provided for @referenceFormat.
  ///
  /// In en, this message translates to:
  /// **'Format: Book Chapter:Verse'**
  String get referenceFormat;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @pleaseEnterReference.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reference.'**
  String get pleaseEnterReference;

  /// No description provided for @notQuiteRight.
  ///
  /// In en, this message translates to:
  /// **'That\'s not quite right. The correct reference is {reference}.'**
  String notQuiteRight(Object reference);

  /// No description provided for @correctReferenceIdentification.
  ///
  /// In en, this message translates to:
  /// **'Great job! You correctly identified this verse as {reference}.'**
  String correctReferenceIdentification(Object reference);

  /// No description provided for @bookAndChapterCorrectButVerseIncorrect.
  ///
  /// In en, this message translates to:
  /// **'You got the book and chapter right, but the verse is incorrect. The correct reference is {reference}.'**
  String bookAndChapterCorrectButVerseIncorrect(Object reference);

  /// No description provided for @bookCorrectButChapterIncorrect.
  ///
  /// In en, this message translates to:
  /// **'You got the book right, but the chapter is incorrect. The correct reference is {reference}.'**
  String bookCorrectButChapterIncorrect(Object reference);

  /// No description provided for @bookIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The book you entered is incorrect. The correct reference is {reference}.'**
  String bookIncorrect(Object reference);

  /// No description provided for @referenceRecall.
  ///
  /// In en, this message translates to:
  /// **'Reference Recall'**
  String get referenceRecall;

  /// No description provided for @referencesDueToday.
  ///
  /// In en, this message translates to:
  /// **'References Due Today'**
  String get referencesDueToday;

  /// No description provided for @priorQuestions.
  ///
  /// In en, this message translates to:
  /// **'Prior Questions'**
  String get priorQuestions;

  /// No description provided for @noPreviousQuestions.
  ///
  /// In en, this message translates to:
  /// **'No previous questions yet'**
  String get noPreviousQuestions;

  /// No description provided for @referenceCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Reference cannot be empty'**
  String get referenceCannotBeEmpty;

  /// No description provided for @invalidBookName.
  ///
  /// In en, this message translates to:
  /// **'Invalid book name'**
  String get invalidBookName;

  /// No description provided for @formatShouldBeBookChapterVerse.
  ///
  /// In en, this message translates to:
  /// **'Format should be \"Book Chapter:Verse\"'**
  String get formatShouldBeBookChapterVerse;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
