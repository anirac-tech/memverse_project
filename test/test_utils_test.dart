import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/utils/test_utils.dart';

void main() {
  group('TestMockDio', () {
    test('should instantiate correctly', () {
      final mockDio = TestMockDio();
      expect(mockDio, isA<TestMockDio>());
    });
  });

  group('DioTypeCheck extension', () {
    test('should return true for TestMockDio instances', () {
      final mockDio = TestMockDio();
      expect(mockDio.isTestMockDio, isTrue);
    });

    test('should return true for objects containing MockDio in toString()', () {
      final mockDioLike = _MockDioLike();
      expect(mockDioLike.isTestMockDio, isTrue);
    });

    test('should return false for null', () {
      const Object? nullObject = null;
      expect(nullObject.isTestMockDio, isFalse);
    });

    test('should return false for non-mock objects', () {
      const regularObject = 'not a mock';
      expect(regularObject.isTestMockDio, isFalse);
    });
  });
}

/// A test class that simulates a mock Dio by having "MockDio" in its toString()
class _MockDioLike {
  @override
  String toString() {
    return 'MockDio_XYZ';
  }
}
