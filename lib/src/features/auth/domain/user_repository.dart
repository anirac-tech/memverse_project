import 'package:memverse/src/features/auth/domain/user.dart';

/// Repository interface for user operations
abstract class UserRepository {
  /// Create a new user account
  Future<User> createUser(String email, String password);

  /// Check if user exists by email
  Future<bool> userExists(String email);
}
