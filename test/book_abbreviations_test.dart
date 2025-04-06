import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';

void main() {
  group('VerseReferenceValidator Abbreviations', () {
    test('isValid should accept valid abbreviations', () {
      // Test that the validator accepts common abbreviations
      expect(VerseReferenceValidator.isValid('Gen 1:1'), isTrue);
      expect(VerseReferenceValidator.isValid('Exo 20:3'), isTrue);
      expect(VerseReferenceValidator.isValid('Ps 23:1'), isTrue);
      expect(VerseReferenceValidator.isValid('Matt 5:1'), isTrue);
      expect(VerseReferenceValidator.isValid('Rom 8:28'), isTrue);
      expect(VerseReferenceValidator.isValid('Phil 4:13'), isTrue);
      expect(VerseReferenceValidator.isValid('Col 1:17'), isTrue);
      expect(VerseReferenceValidator.isValid('Rev 22:21'), isTrue);
    });

    test('isValid should be case-insensitive for abbreviations', () {
      expect(VerseReferenceValidator.isValid('gen 1:1'), isTrue);
      expect(VerseReferenceValidator.isValid('COL 1:17'), isTrue);
      expect(VerseReferenceValidator.isValid('Phil 4:13'), isTrue);
    });

    test('getStandardBookName converts abbreviations to full book names', () {
      expect(VerseReferenceValidator.getStandardBookName('Gen'), equals('Genesis'));
      expect(VerseReferenceValidator.getStandardBookName('gen'), equals('Genesis'));
      expect(VerseReferenceValidator.getStandardBookName('Rom'), equals('Romans'));
      expect(VerseReferenceValidator.getStandardBookName('col'), equals('Colossians'));
      expect(VerseReferenceValidator.getStandardBookName('Phil'), equals('Philippians'));
    });

    test('getStandardBookName preserves full book names', () {
      expect(VerseReferenceValidator.getStandardBookName('Genesis'), equals('Genesis'));
      expect(VerseReferenceValidator.getStandardBookName('Colossians'), equals('Colossians'));
      expect(VerseReferenceValidator.getStandardBookName('Philippians'), equals('Philippians'));
    });

    test('getStandardBookName preserves unknown names', () {
      expect(VerseReferenceValidator.getStandardBookName('NotABook'), equals('NotABook'));
    });
  });
}
