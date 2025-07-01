import 'package:memverse/src/features/auth/data/fake_auth_data.dart';
import 'package:memverse/src/features/auth/domain/user.dart';
import 'package:memverse/src/features/auth/domain/user_repository.dart';

/// Fake user repository for testing
/// Uses JSON literals similar to Square's MockWebServer approach
class FakeUserRepository implements UserRepository {
  @override
  Future<User> createUser(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    // Success case for dummy user
    if (email == 'dummynewuser@dummy.com') {
      final json = FakeAuthData.dummyUserJson;
      return User.fromJson(json['user'] as Map<String, dynamic>);
    }

    // Error case for existing user
    if (email == 'existing@example.com') {
      final errorJson = FakeAuthData.errorJson;
      throw Exception(errorJson['message']);
    }

    // Default error for other emails
    throw Exception('User creation failed');
  }

  @override
  Future<bool> userExists(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 50));

    // Simulate existing user
    return email == 'existing@example.com';
  }
}
