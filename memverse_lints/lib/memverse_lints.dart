import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/avoid_debug_print_rule.dart';
import 'src/avoid_log_rule.dart';

/// This is the entry point for the lint package.
PluginBase createPlugin() {
  return _MemverseLintPlugin();
}

/// A custom lint plugin that provides rules for the Memverse project.
class _MemverseLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [AvoidDebugPrintRule(), AvoidLogRule()];
  }
}
