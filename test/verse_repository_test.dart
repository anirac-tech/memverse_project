import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

import 'verse_repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('VerseRepositoryProvider', () {
    test('instance should return a VerseRepository implementation', () {
      expect(VerseRepositoryProvider.instance, isA<VerseRepository>());
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

  group('LiveVerseRepository', () {
    late MockClient mockClient;
    late LiveVerseRepository repository;

    setUp(() {
      mockClient = MockClient();
      repository = LiveVerseRepository(client: mockClient);
    });

    test('getVerses should return verses from API when request succeeds', () async {
      when(mockClient.get(any)).thenAnswer((_) async => 
        http.Response('''[
          {"ref":"Col 1:17","text":"He existed before anything else, and he holds all creation together"},
          {"ref":"Phil 4:13","text":"For I can do everything through Christ, who gives me strength"}
        ]''', 200));

      final verses = await repository.getVerses();

      expect(verses.length, equals(2));
      expect(verses[0].reference, equals('Col 1:17'));
      expect(verses[0].text, equals('He existed before anything else, and he holds all creation together'));
      expect(verses[1].reference, equals('Phil 4:13'));
      expect(verses[1].text, equals('For I can do everything through Christ, who gives me strength'));
    });

    test('getVerses should return fallback verses when request fails', () async {
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('Server error', 500));

      final verses = await repository.getVerses();

      expect(verses.length, equals(5));
      expect(verses[0].reference, equals('Genesis 1:1'));
    });
    
    test('getVerses should return fallback verses when an exception occurs', () async {
      when(mockClient.get(any)).thenThrow(Exception('Network error'));

      final verses = await repository.getVerses();

      expect(verses.length, equals(5));
      expect(verses[0].reference, equals('Genesis 1:1'));
    });
  });
}