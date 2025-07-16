import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memverse/src/constants/api_constants.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/utils/app_logger.dart';

/// Authentication service for handling login, token storage, and session management
class AuthService {
  /// Create a new AuthService
  AuthService({FlutterSecureStorage? secureStorage, Dio? dio})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      _dio = dio ?? Dio();

  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  static const _tokenKey = 'auth_token';
  static const String _tokenPath = '/oauth/token';
  static const String clientSecret = String.fromEnvironment('MEMVERSE_CLIENT_API_KEY');
  static bool isDummyUser = false;

  /// Attempts to login with the provided credentials
  Future<AuthToken> login(String username, String password, String clientId) async {
    // Dummy user fast-path (bypasses all real auth)
    if (username.toLowerCase() == 'dummysigninuser@dummy.com') {
      isDummyUser = true;
      AppLogger.i('Bypassing authentication: using dummysigninuser');
      final fakeToken = AuthToken(
        accessToken: 'fake_token',
        tokenType: 'bearer',
        scope: 'user',
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        userId: 0,
      );
      await saveToken(fakeToken);
      return fakeToken;
    }
    try {
      AppLogger.i('Attempting login with provided credentials');
      AppLogger.d(
        'LOGIN - Attempting to log in with username: $username and clientId is non-empty: ${clientId.isNotEmpty} and apiKey is non-empty: ${clientSecret.isNotEmpty}',
      );

      const loginUrl = kIsWeb ? '$webApiPrefix$_tokenPath' : '$apiBaseUrl$_tokenPath';
      AppLogger.d('LOGIN - Using URL: $loginUrl');

      final requestData = <String, dynamic>{
        'grant_type': 'password',
        'username': username,
        'password': password,
        'client_id': clientId,
      };
      // Add api_key/client_secret if available
      if (clientSecret.isNotEmpty) {
        requestData['client_secret'] = clientSecret;
        requestData['api_key'] = clientSecret; // try both field names, backend may expect either
      }

      // Use different approach for web vs native for better compatibility
      final response = await _dio.post<Map<String, dynamic>>(
        loginUrl,
        data: kIsWeb ? requestData : FormData.fromMap(requestData),
        options: Options(
          contentType: kIsWeb ? 'application/json' : Headers.formUrlEncodedContentType,
          headers: {'Accept': 'application/json'},
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data!;
        AppLogger.d('LOGIN - Received successful response with token');
        final authToken = AuthToken.fromJson(jsonData);
        AppLogger.d('LOGIN - Raw token type: ${jsonData['token_type']}');
        await saveToken(authToken);
        return authToken;
      } else {
        AppLogger.e('Login failed with status: ${response.statusCode}, response: ${response.data}');
        throw Exception('Login failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      AppLogger.e('Login failed with Dio exception', e);
      throw Exception('Login failed due to Dio error: $e');
    }
  }

  /// Logs the user out by clearing stored token
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
    } catch (e) {
      AppLogger.e('Error during logout', e);
      rethrow;
    }
  }

  /// Checks if the user is logged in by verifying token existence
  Future<bool> isLoggedIn() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      return token != null;
    } catch (e) {
      AppLogger.e('Error checking login status', e);
      return false;
    }
  }

  /// Gets the stored auth token if available
  Future<AuthToken?> getToken() async {
    try {
      final tokenJson = await _secureStorage.read(key: _tokenKey);
      if (tokenJson == null) return null;

      final tokenMap = jsonDecode(tokenJson) as Map<String, dynamic>;
      return AuthToken.fromJson(tokenMap);
    } catch (e) {
      AppLogger.e('Error retrieving token', e);
      return null;
    }
  }

  /// Saves the auth token to secure storage
  Future<void> saveToken(AuthToken token) async {
    try {
      final tokenJson = jsonEncode(token.toJson());
      await _secureStorage.write(key: _tokenKey, value: tokenJson);
    } catch (e) {
      AppLogger.e('Error saving token', e);
      rethrow;
    }
  }
}

class MockAuthService extends AuthService {
  MockAuthService();

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<AuthToken> login(String username, String password, String clientId) async => AuthToken(
    accessToken: 'mock',
    tokenType: 'Bearer',
    scope: 'user',
    createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    userId: 0,
  );

  @override
  Future<void> logout() async {}

  @override
  Future<AuthToken?> getToken() async => AuthToken(
    accessToken: 'mock',
    tokenType: 'Bearer',
    scope: 'user',
    createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    userId: 0,
  );
}
