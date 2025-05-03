# TODO Before Merge - MEM-102 & MEM-112 Branch

This checklist tracks outstanding items that need to be addressed before this branch can be merged
into `main`.

## Current Outstanding Items

- [ ] **Create Jira Ticket for Lint Quick Fixes**: Due to dependency conflicts, the custom lint
  quick fixes for `avoid_debug_print` and `avoid_log` are not currently functional. Create a Jira
  ticket to track the work needed to resolve these conflicts (likely involving aligning `analyzer`,
  `analyzer_plugin`, `dart_style` versions) so that IDE quick fixes can be used.

- [ ] **Resolve Lint Package Conflicts**: Decide on the strategy for the `memverse_lints` package.
  Either fix the dependency conflicts (`analyzer`, `dart_style`) with the main project (
  `riverpod_generator`, `bdd_widget_test`) or temporarily remove/disable the package and its
  configuration (`pubspec.yaml`, `analysis_options.yaml`). *(This might be resolved by the ticket
  above)*

- [ ] **Address PR Feedback**: Review and address specific comments from the CodeRabbit review and
  any manual reviews on the associated Pull Request (e.g., PR #26).

- [ ] **Clean Up Test Files**: Remove the temporary test file `lib/src/test_lint_rule.dart` which
  was used to verify linting but is not part of the application features.

- [ ] **Create Follow-up Jira Ticket**: Create a new Jira ticket to track items identified during
  development/review that are out of scope for this PR but need future attention. This includes:
    - Investigating a permanent fix for the localization file formatting issue (instead of the
      current
      script workaround).
    - Re-evaluating the custom lint package integration once dependency conflicts are less
      problematic (if disabled in the previous step).

- [ ] **Final Verification**: Perform a final check of all changes, run
  `./scripts/check_before_commit.sh`, and ensure all CI checks pass.

---

## TODO Before Merge Template

*Copy and paste this section into future PRs or branch documentation.*

- [ ] **Resolve TODOs**: Search the codebase for `TODO:` comments added in this branch and resolve
  them or create Jira tickets.
- [ ] **Address PR Feedback**: Incorporate feedback from CodeRabbit and manual code reviews.
- [ ] **Run Pre-commit Checks**: Ensure `./scripts/check_before_commit.sh` passes locally.
- [ ] **Check CI Status**: Verify all GitHub Actions checks are green.
- [ ] **Update Documentation**: Ensure relevant documentation (README, CONTRIBUTING, feature docs)
  is up-to-date.
- [ ] **Final Manual Test**: Perform a quick manual test of the affected features.
- [ ] **Create Follow-up Jira Ticket**: Document any technical debt, refactoring opportunities, or
  out-of-scope items identified during development for future work.