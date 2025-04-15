import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';

void main() {
  group('VerseReferenceValidator', () {
    group('isValid', () {
      test('returns true for valid full book name references', () {
        expect(VerseReferenceValidator.isValid('Genesis 1:1'), isTrue);
        expect(VerseReferenceValidator.isValid('Exodus 20:13'), isTrue);
        expect(VerseReferenceValidator.isValid('Psalm 23:1'), isTrue);
        expect(VerseReferenceValidator.isValid('Song of Songs 1:1'), isTrue);
        expect(VerseReferenceValidator.isValid('1 Corinthians 13:4'), isTrue);
        expect(VerseReferenceValidator.isValid('2 Timothy 3:16'), isTrue);
        expect(VerseReferenceValidator.isValid('3 John 1:4'), isTrue);
        expect(VerseReferenceValidator.isValid('Revelation 22:21'), isTrue);
      });

      test('returns true for valid abbreviated book names', () {
        expect(VerseReferenceValidator.isValid('Gen 1:1'), isTrue);
        expect(VerseReferenceValidator.isValid('ps 23:1'), isTrue);
        expect(VerseReferenceValidator.isValid('matt 5:3'), isTrue);
        expect(VerseReferenceValidator.isValid('1 Cor 13:4'), isTrue);
        expect(VerseReferenceValidator.isValid('Rev 22:21'), isTrue);
      });

      test('returns true for references with verse ranges', () {
        expect(VerseReferenceValidator.isValid('Genesis 1:1-2'), isTrue);
        expect(VerseReferenceValidator.isValid('Psalm 23:1-6'), isTrue);
        expect(VerseReferenceValidator.isValid('John 3:16-17'), isTrue);
      });

      test('returns false for empty references', () {
        expect(VerseReferenceValidator.isValid(''), isFalse);
      });

      test('returns false for incorrectly formatted references', () {
        expect(VerseReferenceValidator.isValid('Genesis'), isFalse);
        expect(VerseReferenceValidator.isValid('Genesis 1'), isFalse);
        expect(VerseReferenceValidator.isValid('Genesis:1'), isFalse);
        expect(VerseReferenceValidator.isValid('Genesis 1:'), isFalse);
        expect(VerseReferenceValidator.isValid('1:1'), isFalse);
        expect(VerseReferenceValidator.isValid('Gen 1:a'), isFalse);
        expect(VerseReferenceValidator.isValid('Genesis 1:1:2'), isFalse);
      });

      test('returns false for non-existent book names', () {
        expect(VerseReferenceValidator.isValid('Genesiss 1:1'), isFalse);
        expect(VerseReferenceValidator.isValid('NotABook 1:1'), isFalse);
        expect(VerseReferenceValidator.isValid('4 John 1:1'), isFalse);
      });
    });

    group('getStandardBookName', () {
      test('returns the properly cased full book name for full names', () {
        expect(VerseReferenceValidator.getStandardBookName('genesis'), equals('Genesis'));
        expect(VerseReferenceValidator.getStandardBookName('psalm'), equals('Psalm'));
        expect(
          VerseReferenceValidator.getStandardBookName('Song of Songs'),
          equals('Song of Songs'),
        );
        expect(
          VerseReferenceValidator.getStandardBookName('1 Corinthians'),
          equals('1 Corinthians'),
        );
      });

      test('returns the properly cased full book name for abbreviations', () {
        expect(VerseReferenceValidator.getStandardBookName('gen'), equals('Genesis'));
        expect(VerseReferenceValidator.getStandardBookName('ps'), equals('Psalm'));
        expect(VerseReferenceValidator.getStandardBookName('1 cor'), equals('1 Corinthians'));
        expect(VerseReferenceValidator.getStandardBookName('rev'), equals('Revelation'));
      });

      test('returns the input when not found in either list', () {
        expect(VerseReferenceValidator.getStandardBookName('not a book'), equals('not a book'));
        expect(VerseReferenceValidator.getStandardBookName('unknown'), equals('unknown'));
      });

      test('handles case insensitivity correctly', () {
        expect(VerseReferenceValidator.getStandardBookName('GENESIS'), equals('Genesis'));
        expect(VerseReferenceValidator.getStandardBookName('GeNeSiS'), equals('Genesis'));
        expect(VerseReferenceValidator.getStandardBookName('1 JOHN'), equals('1 John'));
      });
    });

    test('bookSuggestions contains all 66 books of the Bible', () {
      expect(VerseReferenceValidator.bookSuggestions.length, equals(66));
    });

    test('bookAbbreviations contains mappings for common abbreviations', () {
      // Check a few key abbreviations
      expect(VerseReferenceValidator.bookAbbreviations['gen'], equals('Genesis'));
      expect(VerseReferenceValidator.bookAbbreviations['ps'], equals('Psalm'));
      expect(VerseReferenceValidator.bookAbbreviations['matt'], equals('Matthew'));
      expect(VerseReferenceValidator.bookAbbreviations['rev'], equals('Revelation'));
    });
  });
}
