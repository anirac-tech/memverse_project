import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A lint rule that detects usage of `log` function and suggests using `AppLogger.d` instead.
class AvoidLogRule extends DartLintRule {
  /// Constructor
  AvoidLogRule()
    : super(
        code: LintCode(
          name: 'avoid_log',
          problemMessage: 'Avoid using log(). Use AppLogger.d() instead for consistent logging.',
          correctionMessage: 'Replace with AppLogger.d()',
          errorSeverity: ErrorSeverity.ERROR,
        ),
      );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    context.registry.addMethodInvocation((node) {
      // Check if the method being called is log
      if (node.methodName.name == 'log') {
        reporter.reportErrorForNode(code, node, []);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_ReplaceLogWithAppLogger()];
}

class _ReplaceLogWithAppLogger extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((node) {
      // Check if this is the node we're looking to fix
      if (node.sourceRange.intersects(analysisError.sourceRange)) {
        // Only proceed if this is a log call
        if (node.methodName.name == 'log') {
          final changeBuilder = reporter.createChangeBuilder(
            message: 'Replace log with AppLogger.d',
            priority: 80,
          );

          changeBuilder.addDartFileEdit((builder) {
            // Replace the entire method call, preserving the arguments
            builder.addReplacement(node.sourceRange, (edit) {
              // Check if there are arguments
              if (node.argumentList.arguments.isNotEmpty) {
                edit.write('AppLogger.d(${node.argumentList.arguments.first})');
              } else {
                edit.write('AppLogger.d("")');
              }
            });

            // Add the import if needed
            builder.importLibrary(
              uri: 'package:memverse/src/utils/app_logger.dart',
              prefix: null,
              combinators: const [],
            );
          });
        }
      }
    });
  }
}
