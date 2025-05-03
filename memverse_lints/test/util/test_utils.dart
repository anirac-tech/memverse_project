import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Helper function to lint a code snippet with a given rule
Future<LintRuleResult> lintCode(
  DartLintRule rule,
  String code, {
  String filePath = 'test.dart',
  bool useFeatureSet2_17 = false,
}) async {
  // Parse the code
  final parseResult = parseString(
    content: code,
    featureSet:
        useFeatureSet2_17 ? FeatureSet.fromEnableFlags([]) : FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
    path: filePath,
  );

  // Create a resolver for the rule
  final resolver = TestResolver(parseResult);

  // Initialize the test plugin
  final testPlugin = TestPlugin([rule]);

  // Run the rule and collect the results
  final results = await testPlugin.run(resolver);

  return results;
}

/// A simple test plugin that contains a list of lint rules
class TestPlugin extends PluginBase {
  const TestPlugin(this.rules);

  final List<DartLintRule> rules;

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => rules;
}

/// A test resolver that holds the parse result
class TestResolver extends CustomLintResolver {
  TestResolver(this.parseResult);

  final ParseStringResult parseResult;

  @override
  ParseStringResult get result => parseResult;
}
