import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

// Sample auth token for testing
final testAuthToken = AuthToken(
  accessToken: 'test_access_token',
  tokenType: 'Bearer',
  scope: 'public',
  createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
);
