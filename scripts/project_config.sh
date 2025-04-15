# Project configuration settings

# Flutter version - used in CI workflows
# Needs to match the version specified in pubspec.yaml
export FLUTTER_VERSION="3.29.3"

# Test coverage configuration - used in check_before_commit.sh
export MIN_COVERAGE=97

# Coverage exclusions (shell globs) - used in check_before_commit.sh and translated in CI
# Exclude l10n, generated, bootstrap, app views, freezed, and plugin registrant
export COVERAGE_EXCLUDES="lib/l10n/**/* **/*.g.dart lib/src/bootstrap.dart lib/src/app/view/app.dart **/generated/**/* **/*.freezed.dart **/generated_plugin_registrant.dart lib/src/features/auth/presentation/auth_wrapper.dart lib/src/features/auth/presentation/providers/auth_providers.dart"