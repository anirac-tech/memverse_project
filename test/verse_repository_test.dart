import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

void main() {
  group('VerseRepositoryProvider', () {
    test('instance should return a FakeVerseRepository', () {
      expect(VerseRepositoryProvider.instance, isA<FakeVerseRepository>());
    });
  });

  group('FakeVerseRepository', () {
    late FakeVerseRepository repository;

    setUp(() {
      repository = FakeVerseRepository();
    });

    test('getVerses should return a list of 5 verses', () async {
      final verses = await repository.getVerses();

      expect(verses.length, equals(5));
      expect(verses[0], isA<Verse>());
      expect(verses[0].reference, equals('Genesis 1:1'));
      expect(verses[1].reference, equals('John 3:16'));
      expect(verses[2].reference, equals('Proverbs 3:5'));
      expect(verses[3].reference, equals('Philippians 4:13'));
      expect(verses[4].reference, equals('Romans 8:28'));
    });

    test('getVerses should return verses with correct text', () async {
      final verses = await repository.getVerses();

      expect(verses[0].text, equals('In the beginning God created the heavens and the earth.'));
      expect(verses[0].translation, equals('NLT'));
    });
  });
}
