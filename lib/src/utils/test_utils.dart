/// This file contains utility classes for testing purposes
/// It helps avoid circular dependencies when importing mock classes

library test_utils;

/// Mock Dio class for type checking in production code
class TestMockDio {
  // Empty implementation - just used for type checking
}

/// Extension to allow MockDio to be used as TestMockDio in tests
extension DioTypeCheck on dynamic {
  /// Check if this object is a mock that should be treated as TestMockDio
  bool get isTestMockDio => this is TestMockDio || (this != null && toString().contains('MockDio'));
}
