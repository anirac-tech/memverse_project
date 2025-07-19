import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:memverse/src/common/interceptors/curl_logging_interceptor.dart';
import 'package:memverse/src/features/auth/domain/user.dart';
import 'package:memverse/src/features/auth/domain/user_repository.dart';
import 'package:memverse/src/utils/app_logger.dart';

// Data models for signup request
class RegisterUserRequest {
  const RegisterUserRequest({required this.user});

  final RegisterUser user;

  Map<String, dynamic> toJson() => {'user': user.toJson()};
}

class RegisterUser {
  const RegisterUser({required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': password, // Rails typically requires this
  };
}

/// Repository implementation that connects to the memverse.com API
class ApiUserRepository implements UserRepository {
  ApiUserRepository({
    required Dio dio,
    required String clientId,
    required String clientSecret,
    String baseUrl = 'https://www.memverse.com/api',
  }) : _dio = dio,
       _baseUrl = baseUrl,
       _clientId = clientId,
       _clientSecret = clientSecret {
    _configureDio();
  }

  final Dio _dio;
  final String _baseUrl;
  final String _clientId;
  final String _clientSecret;

  void _configureDio() {
    // Generate bearer token credentials like the Kotlin/Java code
    final credentials = _generateEncodedBearerTokenCredentials();
    final basicAuth = 'Basic $credentials';

    // Add curl logging interceptor for debugging
    _dio.interceptors.add(CurlLoggingInterceptor());

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = basicAuth;
          options.headers['Content-Type'] = 'application/json'; // Changed from form-urlencoded
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        },
      ),
    );
  }

  String _generateEncodedBearerTokenCredentials() {
    // Equivalent to the Java/Kotlin TwitterAuthUtils.generateEncodedBearerTokenCredentials()
    final encodedKey = Uri.encodeComponent(_clientId);
    final encodedSecret = Uri.encodeComponent(_clientSecret);
    final combinedCredentials = '$encodedKey:$encodedSecret';
    return base64Encode(utf8.encode(combinedCredentials));
  }

  @override
  Future<User> createUser(String email, String password, String name) async {
    final registerUser = RegisterUser(name: name, email: email, password: password);
    final testUserRequest = RegisterUserRequest(user: registerUser);

    // Try multiple endpoint patterns commonly used in Rails APIs
    final endpointsToTry = [
      '$_baseUrl/v1/users', // Most common Rails API pattern
      '$_baseUrl/1/users', // Original swagger endpoint
      '$_baseUrl/users', // Simple endpoint
    ];

    for (final endpoint in endpointsToTry) {
      try {
        AppLogger.d('Trying endpoint: $endpoint');

        final response = await _dio.post<dynamic>(
          endpoint,
          data: testUserRequest.toJson(),
          options: Options(
            validateStatus: (status) => status != null && status < 500, // Don't throw on 4xx
          ),
        );

        AppLogger.d('Response status: ${response.statusCode} for endpoint: $endpoint');

        if (response.statusCode == 201 || response.statusCode == 200) {
          final userData = response.data;
          return User(id: userData['id']?.toString() ?? '', email: email);
        } else if (response.statusCode == 404) {
          AppLogger.w('404 - Trying next endpoint...');
          continue; // Try next endpoint
        } else {
          // For other errors, throw immediately
          throw Exception('HTTP ${response.statusCode}: ${response.data}');
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 404 && endpoint != endpointsToTry.last) {
          AppLogger.w('404 on $endpoint - Trying next endpoint...');
          continue; // Try next endpoint
        }

        // This is the last endpoint or a non-404 error
        if (e.response?.data != null && e.response!.data is Map) {
          final errorData = e.response!.data as Map;
          final errorMessages = <String>[];
          errorData.forEach((key, value) {
            if (value is List) {
              errorMessages.add('$key ${value.join(', ')}');
            } else {
              errorMessages.add('$key $value');
            }
          });
          throw Exception('Sign-up failed: ${errorMessages.join('; ')}');
        }
        throw Exception('Network error during sign-up: ${e.message}');
      } catch (e) {
        if (endpoint == endpointsToTry.last) {
          throw Exception('Unexpected error during sign-up: $e');
        }
        AppLogger.e('Error on $endpoint - Trying next endpoint: $e');
        continue;
      }
    }

    throw Exception('All signup endpoints failed - check troubleshoot_signup_api_call.md');
  }
}
