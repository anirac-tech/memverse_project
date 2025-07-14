import 'dart:convert';

/// Fake JSON data for authentication testing
/// Similar to Square's MockWebServer approach with JSON literals
class FakeAuthData {
  /// Successful user creation response for dummynewuser@dummy.com
  static const String dummyUserResponse = '''
  {
    "user": {
      "id": "dummy_123",
      "email": "dummynewuser@dummy.com",
      "username": "dummyuser",
      "created_at": "2025-06-30T19:46:00Z"
    },
    "access_token": "dummy_token_12345",
    "token_type": "Bearer",
    "expires_in": 3600
  }''';

  /// Error response for existing users
  static const String errorResponse = '''
  {
    "error": "user_exists",
    "message": "User already exists"
  }''';

  /// Parse dummy user response
  static Map<String, dynamic> get dummyUserJson =>
      jsonDecode(dummyUserResponse) as Map<String, dynamic>;

  /// Parse error response
  static Map<String, dynamic> get errorJson => jsonDecode(errorResponse) as Map<String, dynamic>;
}
