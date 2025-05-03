import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:memverse_lints/src/avoid_debug_print_rule.dart';
import 'package:test/test.dart';

import 'util/test_utils.dart';

void main() {
  group('AvoidDebugPrintRule', () {
    test('reports about debugPrint usage', () async {
      final rule = AvoidDebugPrintRule();

      final result = await lintCode(rule, '''
        import 'package:flutter/foundation.dart';

        void main() {
          debugPrint('This is a debug message');
        }
      ''');

      expect(result.errors, hasLength(1));
      expect(
        result.errors.first.message,
        'Avoid using debugPrint. Use AppLogger.d() instead for consistent logging.',
      );
    });

    test('offers a fix to replace debugPrint with AppLogger.d', () async {
      final rule = AvoidDebugPrintRule();

      final result = await lintCode(rule, '''
        import 'package:flutter/foundation.dart';

        void main() {
          debugPrint('This is a debug message');
        }
      ''');

      expect(result.fixes, hasLength(1));
      expect(
        result.fixes.first.change.sourceChanges.values.first.edits.first.replacement,
        contains('AppLogger.d'),
      );
    });
  });
}
