import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/data/api_user_repository.dart';
import 'package:memverse/src/features/auth/domain/user.dart';
import 'package:mocktail/mocktail.dart';

// Mocktail mock classes
class MockDio extends Mock implements Dio {}

class MockInterceptors extends Mock implements Interceptors {}

void main() {
  late MockDio mockDio;
  late MockInterceptors mockInterceptors;
  late ApiUserRepository repository;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(RequestOptions());
    registerFallbackValue(InterceptorsWrapper());
  });

  setUp(() {
    mockDio = MockDio();
    mockInterceptors = MockInterceptors();

    // Mock the interceptors property
    when(() => mockDio.interceptors).thenReturn(mockInterceptors);
    when(() => mockInterceptors.add(any())).thenReturn(null);

    repository = ApiUserRepository(
      dio: mockDio,
      baseUrl: 'https://api.memverse.com',
      clientId: 'test_client_id',
      clientSecret: 'test_client_secret',
    );
  });

  group('ApiUserRepository', () {
    group('createUser', () {
      test('creates a user when API call is successful', () async {
        // Arrange
        const expectedUser = User(id: '123', email: 'test@example.com');

        when(
          () => mockDio.post<dynamic>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<dynamic>(
            data: {'id': '123'},
            statusCode: 201,
            requestOptions: RequestOptions(),
          ),
        );

        // Act
        final user = await repository.createUser('test@example.com', 'password', 'Test User');

        // Assert
        expect(user.id, equals(expectedUser.id));
        expect(user.email, equals(expectedUser.email));

        // Verify correct API call was made
        verify(
          () => mockDio.post<dynamic>(
            'https://api.memverse.com/1/users',
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('throws exception when API call fails', () async {
        // Arrange
        when(
          () => mockDio.post<dynamic>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response<dynamic>(
              data: {
                'email': ['has already been taken'],
              },
              statusCode: 422,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.createUser('test@example.com', 'password', 'Test User'),
          throwsException,
        );
      });
    });
  });
}
