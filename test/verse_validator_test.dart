import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';

void main() {
  group('VerseReferenceValidator', () {
    test('bookSuggestions should contain common Bible books', () {
      expect(VerseReferenceValidator.bookSuggestions.length, equals(66));
      expect(VerseReferenceValidator.bookSuggestions, contains('Genesis'));
      expect(VerseReferenceValidator.bookSuggestions, contains('Revelation'));
      expect(VerseReferenceValidator.bookSuggestions, contains('Psalm'));
      expect(VerseReferenceValidator.bookSuggestions, contains('John'));
    });

    test('isValid should validate correctly formatted references', () {
      expect(VerseReferenceValidator.isValid('Genesis 1:1'), isTrue);
      expect(VerseReferenceValidator.isValid('John 3:16'), isTrue);
      expect(VerseReferenceValidator.isValid('1 Corinthians 13:4'), isTrue);
      expect(VerseReferenceValidator.isValid('Psalm 23:1'), isTrue);
    });

    test('isValid should reject invalid input', () {
      // Empty string
      expect(VerseReferenceValidator.isValid(''), isFalse);

      // Missing verse
      expect(VerseReferenceValidator.isValid('Genesis 1'), isFalse);

      // Missing chapter and verse
      expect(VerseReferenceValidator.isValid('Genesis'), isFalse);

      // Invalid format
      expect(VerseReferenceValidator.isValid('Genesis:1:1'), isFalse);

      // Non-existent book
      expect(VerseReferenceValidator.isValid('NotABook 1:1'), isFalse);
    });

    test('isValid should handle case-insensitive book names', () {
      expect(VerseReferenceValidator.isValid('genesis 1:1'), isTrue);
      expect(VerseReferenceValidator.isValid('JOHN 3:16'), isTrue);
      expect(VerseReferenceValidator.isValid('1 corinthians 13:4'), isTrue);
    });

    test('isValid should validate verse ranges', () {
      expect(VerseReferenceValidator.isValid('Genesis 1:1-5'), isTrue);
      expect(VerseReferenceValidator.isValid('John 3:16-18'), isTrue);
    });
  });
}
