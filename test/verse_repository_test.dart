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

  group('VerseRepositoryOverrideProvider', () {
    test('should throw UnimplementedError when not overridden', () {
      final container = ProviderContainer();

      expect(
        () => container.read(verseRepositoryOverrideProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('can be overridden for testing', () {
      final fakeRepository = FakeVerseRepository();
      final container = ProviderContainer(
        overrides: [verseRepositoryOverrideProvider.overrideWithValue(fakeRepository)],
      );

      final repository = container.read(verseRepositoryOverrideProvider);
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

    test('constructor validateStatus function properly validates status codes', () {
      final dio = Dio();
      dio.options.validateStatus = (status) {
        return status != null && status >= 200 && status < 400;
      };

      expect(dio.options.validateStatus(200), isTrue);
      expect(dio.options.validateStatus(302), isTrue);
      expect(dio.options.validateStatus(399), isTrue);
      expect(dio.options.validateStatus(400), isFalse);
      expect(dio.options.validateStatus(500), isFalse);
      expect(dio.options.validateStatus(null), isFalse);

      final okResponse = Response<String>(
        data: 'OK',
        statusCode: 200,
        requestOptions: RequestOptions(path: '/'),
      );
      final redirectResponse = Response<String>(
        data: 'Redirect',
        statusCode: 302,
        requestOptions: RequestOptions(path: '/'),
      );
      expect(dio.options.validateStatus(okResponse.statusCode), isTrue);
      expect(dio.options.validateStatus(redirectResponse.statusCode), isTrue);
    });

    test(
      'getVerses should return verses from API when request succeeds with List response',
      () async {
        when(mockDio.get<dynamic>(any)).thenAnswer(
          (_) async => Response<List<dynamic>>(
            data: <Map<String, dynamic>>[
              <String, dynamic>{
                'ref': 'Col 1:17',
                'text': 'He existed before anything else, and he holds all creation together',
              },
              <String, dynamic>{
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
        expect(verses[1].reference, equals('Phil 4:13'));
      },
    );

    test('getVerses should handle string response and parse JSON correctly', () async {
      const jsonString = '''
      [
        {
          "ref": "Psalm 23:1",
          "text": "The LORD is my shepherd; I have all that I need."
        },
        {
          "ref": "Jer 29:11", 
          "text": "For I know the plans I have for you, says the LORD."
        }
      ]
      ''';

      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<String>(
          data: jsonString,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      final verses = await repository.getVerses();

      expect(verses.length, equals(2));
      expect(verses[0].reference, equals('Psalm 23:1'));
      expect(verses[1].reference, equals('Jer 29:11'));
    });

    test('getVerses should throw an exception when request fails with error status code', () async {
      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<String>(
          data: 'Server error',
          statusCode: 500,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      expect(() => repository.getVerses(), throwsException);
    });

    test('getVerses should throw when network error occurs', () async {
      when(
        mockDio.get<dynamic>(any),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '/'), error: 'Network error'));

      expect(() => repository.getVerses(), throwsA(isA<DioException>()));
    });

    test('_parseVerses handles missing or null JSON values', () async {
      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<List<dynamic>>(
          data: <Map<String, dynamic>>[
            <String, dynamic>{'ref': null, 'text': null},
            <String, dynamic>{},
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      final verses = await repository.getVerses();

      expect(verses.length, equals(2));
      expect(verses[0].reference, equals('Unknown reference'));
      expect(verses[0].text, equals('No text available'));
      expect(verses[1].reference, equals('Unknown reference'));
      expect(verses[1].text, equals('No text available'));
    });

    test('getVerses with invalid JSON should throw', () async {
      const jsonString = '["not a proper verse object"]';

      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<String>(
          data: jsonString,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      expect(() => repository.getVerses(), throwsA(isA<TypeError>()));
    });

    test('getVerses with malformed json during parsing should throw', () async {
      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<List<dynamic>>(
          data: <dynamic>[42],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      expect(() => repository.getVerses(), throwsA(isA<TypeError>()));
    });

    test('getVerses should throw when status code is not 200', () async {
      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<String>(
          data: 'Not found',
          statusCode: 404,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      expect(() => repository.getVerses(), throwsException);
    });

    test('getVerses should throw with non-200 status code', () async {
      when(mockDio.get<dynamic>(any)).thenAnswer(
        (_) async => Response<dynamic>(
          data: 'Error response',
          statusCode: 404,
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      expect(() => repository.getVerses(), throwsException);
    });
  });
}
