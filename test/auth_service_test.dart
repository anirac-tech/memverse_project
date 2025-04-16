import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response<Map<String, dynamic>> {}

class MockOptions extends Mock implements Options {}

void main() {
  group('AuthService', () {
    late MockFlutterSecureStorage mockStorage;
    late MockDio mockDio;
    late AuthService authService;

    const tokenKey = 'auth_token';

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      mockDio = MockDio();
      authService = AuthService(secureStorage: mockStorage, dio: mockDio);

      registerFallbackValue(Options());
      registerFallbackValue(Uri());
      registerFallbackValue(Uri.parse('https://www.memverse.com/oauth/token'));
      registerFallbackValue(
        FormData.fromMap({
          'grant_type': 'password',
          'username': 'testuser',
          'password': 'password123',
          'client_id': 'client_123',
        }),
      );
    });

    group('login', () {
      test('successfully logs in and saves token', () async {
        // Arrange
        const username = 'testuser';
        const password = 'password123';
        const clientId = 'client_123';

        final tokenData = {
          'access_token': 'test_access_token',
          'token_type': 'Bearer',
          'scope': 'public',
          'created_at': 1617184800,
        };

        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.data).thenReturn(tokenData);

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        when(
          () => mockStorage.write(key: tokenKey, value: any(named: 'value')),
        ).thenAnswer((_) async {});

        // Act
        final result = await authService.login(username, password, clientId);

        // Assert
        expect(result, isA<AuthToken>());
        expect(result.accessToken, 'test_access_token');
        expect(result.tokenType, 'Bearer');
        expect(result.scope, 'public');
        expect(result.createdAt, 1617184800);

        // Verify token was saved
        verify(() => mockStorage.write(key: tokenKey, value: any(named: 'value'))).called(1);
      });

      test('throws exception when login fails', () async {
        // Arrange
        const username = 'testuser';
        const password = 'wrong_password';
        const clientId = 'client_123';

        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(401);
        when(() => mockResponse.data).thenReturn({'error': 'invalid_grant'});

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(() => authService.login(username, password, clientId), throwsException);
      });

      test('throws exception when dio throws exception', () async {
        // Arrange
        const username = 'testuser';
        const password = 'password123';
        const clientId = 'client_123';

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            error: 'Network error',
            type: DioExceptionType.connectionError,
          ),
        );

        // Act & Assert
        expect(() => authService.login(username, password, clientId), throwsException);
      });

      test('handles exception when saving token fails', () async {
        // Arrange
        when(
          () => mockStorage.write(key: tokenKey, value: any(named: 'value')),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        // We can call _saveToken indirectly through login
        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.data).thenReturn({
          'access_token': 'test_token',
          'token_type': 'Bearer',
          'scope': 'public',
          'created_at': 1617184800,
        });

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        expect(() => authService.login('testuser', 'password123', 'client_123'), throwsException);
      });
    });

    group('logout', () {
      test('successfully logs out by deleting token', () async {
        // Arrange
        when(() => mockStorage.delete(key: tokenKey)).thenAnswer((_) async {});

        // Act
        await authService.logout();

        // Assert
        verify(() => mockStorage.delete(key: tokenKey)).called(1);
      });

      test('throws exception when logout fails', () async {
        // Arrange
        when(() => mockStorage.delete(key: tokenKey)).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => authService.logout(), throwsException);
      });
    });

    group('isLoggedIn', () {
      test('returns true when token exists', () async {
        // Arrange
        when(() => mockStorage.read(key: tokenKey)).thenAnswer((_) async => 'token_json');

        // Act
        final result = await authService.isLoggedIn();

        // Assert
        expect(result, true);
        verify(() => mockStorage.read(key: tokenKey)).called(1);
      });

      test('returns false when token does not exist', () async {
        // Arrange
        when(() => mockStorage.read(key: tokenKey)).thenAnswer((_) async => null);

        // Act
        final result = await authService.isLoggedIn();

        // Assert
        expect(result, false);
        verify(() => mockStorage.read(key: tokenKey)).called(1);
      });

      test('returns false when error occurs', () async {
        // Arrange
        when(() => mockStorage.read(key: tokenKey)).thenThrow(Exception('Storage error'));

        // Act
        final result = await authService.isLoggedIn();

        // Assert
        expect(result, false);
      });
    });

    group('getToken', () {
      test('returns token when exists in storage', () async {
        // Arrange
        final tokenJson = jsonEncode({
          'access_token': 'test_access_token',
          'token_type': 'Bearer',
          'scope': 'public',
          'created_at': 1617184800,
        });

        when(() => mockStorage.read(key: tokenKey)).thenAnswer((_) async => tokenJson);

        // Act
        final result = await authService.getToken();

        // Assert
        expect(result, isA<AuthToken>());
        expect(result!.accessToken, 'test_access_token');
        expect(result.tokenType, 'Bearer');
        expect(result.scope, 'public');
        expect(result.createdAt, 1617184800);
      });

      test('returns null when no token exists', () async {
        // Arrange
        when(() => mockStorage.read(key: tokenKey)).thenAnswer((_) async => null);

        // Act
        final result = await authService.getToken();

        // Assert
        expect(result, isNull);
      });

      test('returns null when error occurs', () async {
        // Arrange
        when(() => mockStorage.read(key: tokenKey)).thenThrow(Exception('Storage error'));

        // Act
        final result = await authService.getToken();

        // Assert
        expect(result, isNull);
      });
    });

    group('saveToken', () {
      test('saves token to secure storage successfully', () async {
        // Arrange
        final token = AuthToken(
          accessToken: 'test_token',
          tokenType: 'Bearer',
          scope: 'public',
          createdAt: 1617184800,
        );

        when(
          () => mockStorage.write(key: tokenKey, value: any(named: 'value')),
        ).thenAnswer((_) async {});

        // Act - directly call saveToken
        await authService.saveToken(token);

        // Assert
        verify(() => mockStorage.write(key: tokenKey, value: any(named: 'value'))).called(1);
      });

      test('handles exception when saving token fails', () async {
        // Arrange
        final token = AuthToken(
          accessToken: 'test_token',
          tokenType: 'Bearer',
          scope: 'public',
          createdAt: 1617184800,
        );

        when(
          () => mockStorage.write(key: tokenKey, value: any(named: 'value')),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => authService.saveToken(token), throwsException);
      });
    });
  });
}
