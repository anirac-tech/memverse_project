import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:memverse/src/features/auth/domain/user.dart';
import 'package:memverse/src/features/auth/domain/user_repository.dart';

/// Repository implementation that connects to the memverse.com API
class ApiUserRepository implements UserRepository {
  ApiUserRepository({required Dio dio, String baseUrl = 'https://www.memverse.com/api'})
    : _dio = dio,
      _baseUrl = baseUrl;
  final Dio _dio;
  final String _baseUrl;

  @override
  Future<User> createUser(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/users',
        data: jsonEncode({
          'user': {'email': email, 'password': password, 'password_confirmation': password},
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final userData = response.data;
        return User(id: userData['id']?.toString() ?? '', email: email);
      } else {
        throw Exception('Failed to create user. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
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
      throw Exception('Unexpected error during sign-up: $e');
    }
  }
}
