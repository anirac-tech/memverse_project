import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/src/features/auth/data/api_user_repository.dart';
import 'package:memverse/src/features/auth/data/fake_user_repository.dart';
import 'package:memverse/src/features/auth/domain/user_repository.dart';

/// Provider for UserRepository
/// In production, it provides ApiUserRepository.
/// In tests, it can be overridden to provide FakeUserRepository.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = Dio();

  // For development, we can determine which implementation to use
  // based on environment variables or build configuration
  var useFakeRepository = false;
  assert(() {
    // In debug mode, check an environment variable or other configuration
    // This is a placeholder - implement your own logic here
    useFakeRepository = false;
    return true;
  }());

  if (useFakeRepository) {
    return FakeUserRepository();
  }

  // Get client credentials from environment variables
  const clientId = String.fromEnvironment('CLIENT_ID');
  const clientSecret = String.fromEnvironment('CLIENT_API_KEY');

  return ApiUserRepository(dio: dio, clientId: clientId, clientSecret: clientSecret);
});
