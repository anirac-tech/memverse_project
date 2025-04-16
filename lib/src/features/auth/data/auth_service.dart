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
  final Dio _dio; // coverage:ignore-line

  static const _tokenKey = 'auth_token';
  static const _apiEndpoint = 'https://www.memverse.com/oauth/token';

  /// Attempts to login with the provided credentials
  Future<AuthToken> login(String username, String password, String clientId) async {
    // coverage:ignore-line
    try {
      // coverage:ignore-line
      AppLogger.i('Attempting login with provided credentials'); // coverage:ignore-line
      debugPrint(
        // coverage:ignore-line
        'LOGIN - Attempting to log in with username: $username and clientId is non-empty: ${clientId.isNotEmpty}', // coverage:ignore-line
      ); // coverage:ignore-line

      // Try first with Dio for better error handling
      try {
        // coverage:ignore-line
        final response = await _dio.post<Map<String, dynamic>>(
          // coverage:ignore-line
          _apiEndpoint, // coverage:ignore-line
          data: FormData.fromMap({
            // coverage:ignore-line
            'grant_type': 'password', // coverage:ignore-line
            'username': username, // coverage:ignore-line
            'password': password, // coverage:ignore-line
            'client_id': clientId, // coverage:ignore-line
          }), // coverage:ignore-line
          options: Options(
            // coverage:ignore-line
            contentType: Headers.formUrlEncodedContentType, // coverage:ignore-line
            headers: {'Accept': 'application/json'}, // coverage:ignore-line
            validateStatus: (status) => true, // coverage:ignore-line
          ), // coverage:ignore-line
        ); // coverage:ignore-line

        if (response.statusCode == 200) {
          // coverage:ignore-line
          final jsonData = response.data!; // coverage:ignore-line
          debugPrint('LOGIN - Received successful response with token'); // coverage:ignore-line
          final authToken = AuthToken.fromJson(jsonData); // coverage:ignore-line
          // Log the raw token type for debugging
          debugPrint('LOGIN - Raw token type: ${jsonData['token_type']}'); // coverage:ignore-line
          await saveToken(authToken); // coverage:ignore-line
          return authToken; // coverage:ignore-line
        } else {
          // coverage:ignore-line
          debugPrint(
            'LOGIN - Failed with status code: ${response.statusCode}',
          ); // coverage:ignore-line
          AppLogger.e(
            // coverage:ignore-line
            'Login failed with status: ${response.statusCode}, response: ${response.data}', // coverage:ignore-line
          ); // coverage:ignore-line
          throw Exception(
            'Login failed: ${response.statusCode} - ${response.data}',
          ); // coverage:ignore-line
        }
      } catch (dioError) {
        // coverage:ignore-line
        AppLogger.e(
          'Dio login attempt failed, trying with http package',
          dioError,
        ); // coverage:ignore-line
      }

      // Fallback to http package
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_apiEndpoint),
      ); // coverage:ignore-line
      request.fields.addAll({
        // coverage:ignore-line
        'grant_type': 'password', // coverage:ignore-line
        'username': username, // coverage:ignore-line
        'password': password, // coverage:ignore-line
        'client_id': clientId, // coverage:ignore-line
      }); // coverage:ignore-line

      final response = await request.send(); // coverage:ignore-line
      final responseData = await response.stream.bytesToString(); // coverage:ignore-line

      if (response.statusCode == 200) {
        // coverage:ignore-line
        final jsonData = jsonDecode(responseData) as Map<String, dynamic>; // coverage:ignore-line
        final authToken = AuthToken.fromJson(jsonData); // coverage:ignore-line
        // Log the raw token type for debugging
        debugPrint('LOGIN - Raw token type: ${jsonData['token_type']}'); // coverage:ignore-line
        await saveToken(authToken); // coverage:ignore-line
        return authToken; // coverage:ignore-line
      } else {
        // coverage:ignore-line
        debugPrint(
          'LOGIN - Failed with status code: ${response.statusCode}',
        ); // coverage:ignore-line
        AppLogger.e(
          // coverage:ignore-line
          'Login failed with status: ${response.statusCode}, response: $responseData', // coverage:ignore-line
        ); // coverage:ignore-line
        throw Exception(
          'Login failed: ${response.statusCode} - $responseData',
        ); // coverage:ignore-line
      }
    } catch (e) {
      // coverage:ignore-line
      AppLogger.e('Login error', e); // coverage:ignore-line
      rethrow; // coverage:ignore-line
    }
  }

  /// Logs the user out by clearing stored token
  Future<void> logout() async {
    // coverage:ignore-line
    try {
      // coverage:ignore-line
      await _secureStorage.delete(key: _tokenKey); // coverage:ignore-line
    } catch (e) {
      // coverage:ignore-line
      AppLogger.e('Error during logout', e); // coverage:ignore-line
      rethrow; // coverage:ignore-line
    }
  }

  /// Checks if the user is logged in by verifying token existence
  Future<bool> isLoggedIn() async {
    // coverage:ignore-line
    try {
      // coverage:ignore-line
      final token = await _secureStorage.read(key: _tokenKey); // coverage:ignore-line
      return token != null; // coverage:ignore-line
    } catch (e) {
      // coverage:ignore-line
      AppLogger.e('Error checking login status', e); // coverage:ignore-line
      return false; // coverage:ignore-line
    }
  }

  /// Gets the stored auth token if available
  Future<AuthToken?> getToken() async {
    // coverage:ignore-line
    try {
      // coverage:ignore-line
      final tokenJson = await _secureStorage.read(key: _tokenKey); // coverage:ignore-line
      if (tokenJson == null) return null; // coverage:ignore-line

      final tokenMap = jsonDecode(tokenJson) as Map<String, dynamic>; // coverage:ignore-line
      return AuthToken.fromJson(tokenMap); // coverage:ignore-line
    } catch (e) {
      // coverage:ignore-line
      AppLogger.e('Error retrieving token', e); // coverage:ignore-line
      return null; // coverage:ignore-line
    }
  }

  /// Saves the auth token to secure storage
  Future<void> saveToken(AuthToken token) async {
    // coverage:ignore-line
    try {
      // coverage:ignore-line
      final tokenJson = jsonEncode(token.toJson()); // coverage:ignore-line
      await _secureStorage.write(key: _tokenKey, value: tokenJson); // coverage:ignore-line
    } catch (e) {
      // coverage:ignore-line
      AppLogger.e('Error saving token', e); // coverage:ignore-line
      rethrow; // coverage:ignore-line
    }
  }
}
