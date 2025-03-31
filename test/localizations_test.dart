import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations_en.dart';
import 'package:memverse/l10n/arb/app_localizations_es.dart';

void main() {
  group('AppLocalizations', () {
    test('AppLocalizationsEn provides correct translations', () {
      final localizations = AppLocalizationsEn();
      expect(localizations.question, equals('Question'));
      expect(localizations.reference, equals('Reference:'));
      expect(localizations.submit, equals('Submit'));
      expect(localizations.correct, equals('Correct!'));
      expect(localizations.correctReferenceIdentification('Genesis 1:1'), contains('Genesis 1:1'));
      expect(localizations.referenceTest, equals('Reference Test'));
      expect(localizations.referenceRecall, equals('Reference Recall'));
      expect(localizations.referencesDueToday, equals('References Due Today'));
      expect(localizations.priorQuestions, equals('Prior Questions'));
      expect(localizations.noPreviousQuestions, equals('No previous questions yet'));
      expect(localizations.pleaseEnterReference, isNotEmpty);
      expect(localizations.invalidBookName, isNotEmpty);
      expect(localizations.formatShouldBeBookChapterVerse, isNotEmpty);
      expect(localizations.enterReferenceHint, isNotEmpty);
      expect(localizations.referenceFormat, isNotEmpty);
      expect(localizations.notQuiteRight('Genesis 1:1'), contains('Genesis 1:1'));
      expect(
        localizations.bookAndChapterCorrectButVerseIncorrect('Genesis 1:1'),
        contains('Genesis 1:1'),
      );
      expect(localizations.bookCorrectButChapterIncorrect('Genesis 1:1'), contains('Genesis 1:1'));
      expect(localizations.bookIncorrect('Genesis 1:1'), contains('Genesis 1:1'));
      expect(localizations.referenceCannotBeEmpty, isNotEmpty);
    });

    test('AppLocalizationsEs provides correct translations', () {
      final localizations = AppLocalizationsEs();
      expect(localizations.question, equals('Pregunta'));
      expect(localizations.reference, equals('Referencia:'));
      expect(localizations.submit, equals('Enviar'));
      expect(localizations.correct, equals('¡Correcto!'));
      expect(localizations.correctReferenceIdentification('Genesis 1:1'), contains('Genesis 1:1'));
      expect(localizations.referenceTest, equals('Prueba de Referencias'));
      expect(localizations.referenceRecall, equals('Recuerdo de Referencias'));
      expect(localizations.referencesDueToday, equals('Referencias por Revisar Hoy'));
      expect(localizations.priorQuestions, equals('Preguntas Anteriores'));
      expect(localizations.noPreviousQuestions, equals('Aún no hay preguntas anteriores'));
      expect(localizations.pleaseEnterReference, isNotEmpty);
      expect(localizations.invalidBookName, isNotEmpty);
      expect(localizations.formatShouldBeBookChapterVerse, isNotEmpty);
      expect(localizations.enterReferenceHint, isNotEmpty);
      expect(localizations.referenceFormat, isNotEmpty);
      expect(localizations.notQuiteRight('Genesis 1:1'), contains('Genesis 1:1'));
      expect(
        localizations.bookAndChapterCorrectButVerseIncorrect('Genesis 1:1'),
        contains('Genesis 1:1'),
      );
      expect(localizations.bookCorrectButChapterIncorrect('Genesis 1:1'), contains('Genesis 1:1'));
      expect(localizations.bookIncorrect('Genesis 1:1'), contains('Genesis 1:1'));
      expect(localizations.referenceCannotBeEmpty, isNotEmpty);
    });
  });
}
