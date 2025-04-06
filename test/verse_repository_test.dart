import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'verse_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('VerseRepositoryProvider', () {
    test('should provide a VerseRepository instance', () {
      final container = ProviderContainer();
      final repository = container.read(verseRepositoryProvider);

      expect(repository, isA<VerseRepository>());
      expect(repository, isA<LiveVerseRepository>());
    });

    test('can be overridden for testing', () {
      final fakeRepository = FakeVerseRepository();
      final container = ProviderContainer(
        overrides: [verseRepositoryProvider.overrideWithValue(fakeRepository)],
      );

      final repository = container.read(verseRepositoryProvider);
      expect(repository, same(fakeRepository));
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
    late MockDio mockDio;
    late LiveVerseRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = LiveVerseRepository(dio: mockDio);
    });

    test('getVerses should return verses from API when request succeeds', () async {
      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<List<dynamic>>(
          data: [
            {
              'ref': 'Col 1:17',
              'text': 'He existed before anything else, and he holds all creation together',
            },
            {
              'ref': 'Phil 4:13',
              'text': 'For I can do everything through Christ, who gives me strength',
            },
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      final verses = await repository.getVerses();

      expect(verses.length, equals(2));
      expect(verses[0].reference, equals('Col 1:17'));
      expect(
        verses[0].text,
        equals('He existed before anything else, and he holds all creation together'),
      );
      expect(verses[1].reference, equals('Phil 4:13'));
      expect(
        verses[1].text,
        equals('For I can do everything through Christ, who gives me strength'),
      );
    });

    test('getVerses should return fallback verses when request fails', () async {
      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<String>(
          data: 'Server error',
          statusCode: 500,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      final verses = await repository.getVerses();

      expect(verses.length, equals(5));
      expect(verses[0].reference, equals('Genesis 1:1'));
    });

    test('getVerses should return fallback verses when an exception occurs', () async {
      when(mockDio.get<dynamic>(any)).thenThrow(Exception('Network error'));

      final verses = await repository.getVerses();

      expect(verses.length, equals(5));
      expect(verses[0].reference, equals('Genesis 1:1'));
    });
  });
}
