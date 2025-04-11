import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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
  static const _apiEndpoint = 'https://www.memverse.com/oauth/token';

  /// Attempts to login with the provided credentials
  Future<AuthToken> login(String username, String password, String clientId) async {
    try {
      AppLogger.i('Attempting login with provided credentials');
      debugPrint(
        'LOGIN - Attempting to log in with username: $username and clientId is non-empty: ${clientId.isNotEmpty}',
      );

      // Try first with Dio for better error handling
      try {
        final response = await _dio.post<Map<String, dynamic>>(
          _apiEndpoint,
          data: FormData.fromMap({
            'grant_type': 'password',
            'username': username,
            'password': password,
            'client_id': clientId,
          }),
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {'Accept': 'application/json'},
            validateStatus: (status) => true, // Accept all status codes for better error logging
          ),
        );

        if (response.statusCode == 200) {
          final jsonData = response.data!;
          debugPrint('LOGIN - Received successful response with token');
          final authToken = AuthToken.fromJson(jsonData);
          // Log the raw token type for debugging
          debugPrint('LOGIN - Raw token type: ${jsonData['token_type']}');
          await _saveToken(authToken);
          return authToken;
        } else {
          debugPrint('LOGIN - Failed with status code: ${response.statusCode}');
          AppLogger.e(
            'Login failed with status: ${response.statusCode}, response: ${response.data}',
          );
          throw Exception('Login failed: ${response.statusCode} - ${response.data}');
        }
      } catch (dioError) {
        // If Dio fails, fall back to http package
        AppLogger.e('Dio login attempt failed, trying with http package', dioError);
      }

      // Fallback to http package
      final request = http.MultipartRequest('POST', Uri.parse(_apiEndpoint));
      request.fields.addAll({
        'grant_type': 'password',
        'username': username,
        'password': password,
        'client_id': clientId,
      });

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseData) as Map<String, dynamic>;
        final authToken = AuthToken.fromJson(jsonData);
        // Log the raw token type for debugging
        debugPrint('LOGIN - Raw token type: ${jsonData['token_type']}');
        await _saveToken(authToken);
        return authToken;
      } else {
        AppLogger.e('Login failed with status: ${response.statusCode}, response: $responseData');
        throw Exception('Login failed: ${response.statusCode} - $responseData');
      }
    } catch (e) {
      AppLogger.e('Login error', e);
      rethrow;
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
  Future<void> _saveToken(AuthToken token) async {
    try {
      final tokenJson = jsonEncode(token.toJson());
      await _secureStorage.write(key: _tokenKey, value: tokenJson);
    } catch (e) {
      AppLogger.e('Error saving token', e);
      rethrow;
    }
  }
}
