import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/data/api_user_repository.dart';
import 'package:memverse/src/features/auth/domain/user.dart';
import 'package:mocktail/mocktail.dart';

// Mocktail mock class
class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ApiUserRepository repository;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    mockDio = MockDio();
    repository = ApiUserRepository(dio: mockDio, baseUrl: 'https://api.memverse.com');
  });

  group('ApiUserRepository', () {
    group('createUser', () {
      test('creates a user when API call is successful', () async {
        // Arrange
        const expectedUser = User(id: '123', email: 'test@example.com');

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async =>
              Response(data: {'id': '123'}, statusCode: 201, requestOptions: RequestOptions()),
        );

        // Act
        final user = await repository.createUser('test@example.com', 'password');

        // Assert
        expect(user.id, equals(expectedUser.id));
        expect(user.email, equals(expectedUser.email));

        // Verify correct API call was made
        verify(
          () => mockDio.post(
            'https://api.memverse.com/users',
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('throws exception when API call fails', () async {
        // Arrange
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              data: {
                'email': ['has already been taken'],
              },
              statusCode: 422,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        // Act & Assert
        expect(() => repository.createUser('test@example.com', 'password'), throwsException);
      });
    });
  });
}
