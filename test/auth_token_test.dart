import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';

void main() {
  group('AuthToken', () {
    test('should create AuthToken from constructor', () {
      // Arrange
      const accessToken = 'test_token';
      const tokenType = 'Bearer';
      const scope = 'public';
      const createdAt = 1617184800;
      const userId = 123;

      // Act
      final token = AuthToken(
        accessToken: accessToken,
        tokenType: tokenType,
        scope: scope,
        createdAt: createdAt,
        userId: userId,
      );

      // Assert
      expect(token.accessToken, accessToken);
      expect(token.tokenType, tokenType);
      expect(token.scope, scope);
      expect(token.createdAt, createdAt);
      expect(token.userId, userId);
    });

    test('should create AuthToken from JSON', () {
      // Arrange
      final json = {
        'access_token': 'test_token',
        'token_type': 'Bearer',
        'scope': 'public',
        'created_at': 1617184800,
        'user_id': 123,
      };

      // Act
      final token = AuthToken.fromJson(json);

      // Assert
      expect(token.accessToken, 'test_token');
      expect(token.tokenType, 'Bearer');
      expect(token.scope, 'public');
      expect(token.createdAt, 1617184800);
      expect(token.userId, 123);
    });

    test('should create AuthToken from JSON without userId', () {
      // Arrange
      final json = {
        'access_token': 'test_token',
        'token_type': 'Bearer',
        'scope': 'public',
        'created_at': 1617184800,
      };

      // Act
      final token = AuthToken.fromJson(json);

      // Assert
      expect(token.accessToken, 'test_token');
      expect(token.tokenType, 'Bearer');
      expect(token.scope, 'public');
      expect(token.createdAt, 1617184800);
      expect(token.userId, null);
    });

    test('should convert AuthToken to JSON with userId', () {
      // Arrange
      final token = AuthToken(
        accessToken: 'test_token',
        tokenType: 'Bearer',
        scope: 'public',
        createdAt: 1617184800,
        userId: 123,
      );

      // Act
      final json = token.toJson();

      // Assert
      expect(json, {
        'access_token': 'test_token',
        'token_type': 'Bearer',
        'scope': 'public',
        'created_at': 1617184800,
        'user_id': 123,
      });
    });

    test('should convert AuthToken to JSON without userId', () {
      // Arrange
      final token = AuthToken(
        accessToken: 'test_token',
        tokenType: 'Bearer',
        scope: 'public',
        createdAt: 1617184800,
      );

      // Act
      final json = token.toJson();

      // Assert
      expect(json, {
        'access_token': 'test_token',
        'token_type': 'Bearer',
        'scope': 'public',
        'created_at': 1617184800,
      });
      expect(json.containsKey('user_id'), false);
    });
  });
}
