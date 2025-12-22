import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memverse/src/common/interceptors/curl_logging_interceptor.dart';
import 'package:memverse/src/constants/api_constants.dart';
import 'package:memverse/src/features/auth/data/auth_api.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/utils/app_logger.dart';

const String clientSecret = String.fromEnvironment('MEMVERSE_CLIENT_API_KEY');

/// Authentication service for handling login, token storage, and session management
///
/// IMPORTANT: Memverse API has different base URLs for different endpoints:
/// - OAuth endpoint (native): https://www.memverse.com/oauth/token (root level)
/// - OAuth endpoint (web): /oauth/token (Netlify proxy)
/// - Other API endpoints (native): https://www.memverse.com/api/v1/* (versioned path)
/// - Other API endpoints (web): /api/* (Netlify proxy)
///
/// This is why AuthApi uses different base URLs for web vs native platforms
class AuthService {
  /// Create a new AuthService
  AuthService({FlutterSecureStorage? secureStorage, Dio? dio, AuthApi? authApi})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      _authApi =
          authApi ??
          // CRITICAL: OAuth endpoint routing depends on platform:
          // - Web: Uses Netlify proxy at /oauth/token (relative URL)
          // - Native: Uses direct HTTPS at https://www.memverse.com/oauth/token
          AuthApi(
            _createDioWithLogging(dio),
            baseUrl: kIsWeb ? webOAuthPrefix : 'https://www.memverse.com',
          );

  static Dio _createDioWithLogging(Dio? dio) {
    final dioInstance = dio ?? Dio();

    // Add curl logging to see exactly what's sent
    dioInstance.interceptors.add(CurlLoggingInterceptor());

    // Add detailed request/response logging
    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.i('🚀 OAuth Request: ${options.method} ${options.uri}');
          AppLogger.i('📝 Headers: ${options.headers}');
          AppLogger.i('📦 Data: ${options.data}');
          AppLogger.i('📋 Content-Type: ${options.contentType}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.i('✅ OAuth Response: ${response.statusCode}');
          AppLogger.i('📝 Response Headers: ${response.headers}');
          AppLogger.i('📦 Response Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.e('❌ OAuth Error: ${error.message}');
          AppLogger.e('🔍 Request: ${error.requestOptions.method} ${error.requestOptions.uri}');
          AppLogger.e('📝 Request Headers: ${error.requestOptions.headers}');
          AppLogger.e('📦 Request Data: ${error.requestOptions.data}');
          if (error.response != null) {
            AppLogger.e('📥 Error Response: ${error.response?.data}');
            AppLogger.e('🔢 Status Code: ${error.response?.statusCode}');
          }
          handler.next(error);
        },
      ),
    );

    return dioInstance;
  }

  final FlutterSecureStorage _secureStorage;
  final AuthApi _authApi;

  static const _tokenKey = 'auth_token';
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

      final authToken = await _authApi.getBearerToken(
        'password',
        username,
        password,
        clientId,
        clientSecret,
      );
      AppLogger.d('LOGIN - Received successful response with token $authToken');
      AppLogger.d('LOGIN - Raw token type: ${authToken.tokenType}');
      await saveToken(authToken);
      return authToken;
    } catch (e) {
      AppLogger.e('Login failed with AuthApi/Retrofit exception', e);
      throw Exception('Login failed via Retrofit: $e');
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
