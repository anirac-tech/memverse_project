import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

void main() {
  group('Verse', () {
    test('should create a verse with required parameters', () {
      const text = 'In the beginning God created the heavens and the earth.';
      const reference = 'Genesis 1:1';

      const verse = Verse(text: text, reference: reference);

      expect(verse.text, equals(text));
      expect(verse.reference, equals(reference));
      expect(verse.translation, equals('NLT')); // default value
    });

    test('should create a verse with custom translation', () {
      const text = 'For God so loved the world...';
      const reference = 'John 3:16';
      const translation = 'NIV';

      const verse = Verse(text: text, reference: reference);

      expect(verse.text, equals(text));
      expect(verse.reference, equals(reference));
      expect(verse.translation, equals(translation));
    });
  });
}
