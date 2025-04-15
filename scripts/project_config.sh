
# Project configuration settings

# Test coverage configuration - used in check_before_commit.sh
export MIN_COVERAGE=90

# Coverage exclusions - used in check_before_commit.sh and coverage commands
export COVERAGE_EXCLUDES="lib/l10n/**/* **/*.g.dart lib/src/bootstrap.dart lib/src/app/app.dart"