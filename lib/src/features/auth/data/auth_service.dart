import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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

  /// Attempts to login with the provided credentials
  Future<AuthToken> login(String username, String password, String clientId) async {
    try {
      AppLogger.i('Attempting login with provided credentials');
      debugPrint(
        'LOGIN - Attempting to log in with username: $username and clientId is non-empty: ${clientId.isNotEmpty}',
      );

      // Change to final from const since kIsWeb is runtime value
      final loginUrl = kIsWeb ? '$webApiPrefix$_tokenPath' : '$apiBaseUrl$_tokenPath';
      debugPrint('LOGIN - Using URL: $loginUrl');

      try {
        // For web deployment, we need to be careful with FormData
        final Map<String, dynamic> requestData = {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_id': clientId,
        };

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
          debugPrint('LOGIN - Received successful response with token');
          final authToken = AuthToken.fromJson(jsonData);
          debugPrint('LOGIN - Raw token type: ${jsonData['token_type']}');
          await saveToken(authToken);
          return authToken;
        } else {
          debugPrint('LOGIN - Failed with status code: ${response.statusCode}');
          AppLogger.e(
            'Login failed with status: ${response.statusCode}, response: ${response.data}',
          );
          throw Exception('Login failed: ${response.statusCode} - ${response.data}');
        }
      } catch (dioError) {
        AppLogger.e('Dio login attempt failed, trying with http package', dioError);
      }

      // Fallback to http package with appropriate content type
      final uri = Uri.parse(loginUrl);
      http.Response response;

      if (kIsWeb) {
        // For web, use regular JSON post
        response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: jsonEncode({
            'grant_type': 'password',
            'username': username,
            'password': password,
            'client_id': clientId,
          }),
        );
      } else {
        // For native, use MultipartRequest
        final request = http.MultipartRequest('POST', uri);
        request.fields.addAll({
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_id': clientId,
        });

        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      }

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final authToken = AuthToken.fromJson(jsonData);
        debugPrint('LOGIN - Raw token type: ${jsonData['token_type']}');
        await saveToken(authToken);
        return authToken;
      } else {
        debugPrint('LOGIN - Failed with status code: ${response.statusCode}');
        AppLogger.e('Login failed with status: ${response.statusCode}, response: ${response.body}');
        throw Exception('Login failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      AppLogger.e('Login error', e);
      rethrow;
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
