import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';

void main() {
  group('VerseReferenceValidator', () {
    test('isValid rejects various invalid inputs', () {
      // Test that the validator correctly rejects invalid references
      expect(VerseReferenceValidator.isValid('Genesis:1:1'), isFalse); // Wrong format
      expect(VerseReferenceValidator.isValid('Genesis 1'), isFalse); // No verse
      expect(VerseReferenceValidator.isValid('Genesis'), isFalse); // No chapter/verse
      expect(VerseReferenceValidator.isValid(''), isFalse); // Empty
      expect(VerseReferenceValidator.isValid('NotABook 1:1'), isFalse); // Invalid book
      expect(VerseReferenceValidator.isValid('1:1'), isFalse); // Missing book
    });

    test('isValid accepts valid references with varied formats', () {
      // Test that the validator accepts valid references
      expect(VerseReferenceValidator.isValid('Genesis 1:1'), isTrue);
      expect(VerseReferenceValidator.isValid('1 Corinthians 13:4'), isTrue); // Book with number
      expect(VerseReferenceValidator.isValid('Song of Songs 1:1'), isTrue); // Multi-word book
      expect(VerseReferenceValidator.isValid('Psalm 23:1'), isTrue);

      // Test case insensitivity
      expect(VerseReferenceValidator.isValid('genesis 1:1'), isTrue); // All lowercase
      expect(VerseReferenceValidator.isValid('JOHN 3:16'), isTrue); // All uppercase
      expect(VerseReferenceValidator.isValid('Revelation 22:21'), isTrue); // Mixed case

      // Test verse ranges
      expect(VerseReferenceValidator.isValid('Genesis 1:1-3'), isTrue); // Verse range
    });
  });

  group('BookSuggestions', () {
    test('bookSuggestions contains all 66 books of the Bible', () {
      expect(VerseReferenceValidator.bookSuggestions.length, equals(66));

      // Check a sample of Old Testament books
      expect(VerseReferenceValidator.bookSuggestions, contains('Genesis'));
      expect(VerseReferenceValidator.bookSuggestions, contains('Exodus'));
      expect(VerseReferenceValidator.bookSuggestions, contains('Psalm'));
      expect(VerseReferenceValidator.bookSuggestions, contains('Isaiah'));

      // Check a sample of New Testament books
      expect(VerseReferenceValidator.bookSuggestions, contains('Matthew'));
      expect(VerseReferenceValidator.bookSuggestions, contains('John'));
      expect(VerseReferenceValidator.bookSuggestions, contains('Acts'));
      expect(VerseReferenceValidator.bookSuggestions, contains('Revelation'));

      // Check books with numbers
      expect(VerseReferenceValidator.bookSuggestions, contains('1 Samuel'));
      expect(VerseReferenceValidator.bookSuggestions, contains('2 Kings'));
      expect(VerseReferenceValidator.bookSuggestions, contains('1 Corinthians'));
      expect(VerseReferenceValidator.bookSuggestions, contains('3 John'));

      // Check multi-word books
      expect(VerseReferenceValidator.bookSuggestions, contains('Song of Songs'));
    });
  });
}
