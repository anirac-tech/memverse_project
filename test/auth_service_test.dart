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
  });
}
