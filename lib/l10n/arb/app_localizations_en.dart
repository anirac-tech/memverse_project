// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Memverse';

  @override
  String get referenceTestAppBarTitle => 'Reference Test';

  @override
  String get referenceTest => 'Reference Test';

  @override
  String get question => 'Question';

  @override
  String get reference => 'Reference:';

  @override
  String get enterReferenceHint => 'Enter reference (e.g., Genesis 1:1)';

  @override
  String get referenceFormat => 'Format: Book Chapter:Verse';

  @override
  String get submit => 'Submit';

  @override
  String get correct => 'Correct!';

  @override
  String get pleaseEnterReference => 'Please enter a reference.';

  @override
  String notQuiteRight(Object reference) {
    return 'That\'s not quite right. The correct reference is $reference.';
  }

  @override
  String correctReferenceIdentification(Object reference) {
    return 'Great job! You correctly identified this verse as $reference.';
  }

  @override
  String bookAndChapterCorrectButVerseIncorrect(Object reference) {
    return 'You got the book and chapter right, but the verse is incorrect. The correct reference is $reference.';
  }

  @override
  String bookCorrectButChapterIncorrect(Object reference) {
    return 'You got the book right, but the chapter is incorrect. The correct reference is $reference.';
  }

  @override
  String bookIncorrect(Object reference) {
    return 'The book you entered is incorrect. The correct reference is $reference.';
  }

  @override
  String get referenceRecall => 'Reference Recall';

  @override
  String get referencesDueToday => 'References Due Today';

  @override
  String get priorQuestions => 'Prior Questions';

  @override
  String get noPreviousQuestions => 'No previous questions yet';

  @override
  String get referenceCannotBeEmpty => 'Reference cannot be empty';

  @override
  String get invalidBookName => 'Invalid book name';

  @override
  String get formatShouldBeBookChapterVerse => 'Format should be \"Book Chapter:Verse\"';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get pleaseEnterYourPassword => 'Please enter your password';

  @override
  String get username => 'Username';

  @override
  String get pleaseEnterYourUsername => 'Please enter your username';

  @override
  String get login => 'Login';
}
