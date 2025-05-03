# TODO Before Merge - MEM-102 & MEM-112 Branch

This checklist tracks outstanding items that need to be addressed before this branch can be merged
into `main`.

## Current Outstanding Items

- [ ] **Address PR Feedback**: Review and address specific comments from the CodeRabbit review and
  any manual reviews on the associated Pull Request (e.g., PR #26).

- [ ] **Clean Up Test Files**: Remove the temporary test file `lib/src/test_lint_rule.dart` which
  was used to verify linting but is not part of the application features.

- [ ] **Create Follow-up Jira Ticket**: Create a new Jira ticket to track items identified during
  development/review that are out of scope for this PR but need future attention. This includes:
    - Investigating a permanent fix for the localization file formatting issue (instead of the
      current script workaround).

- [ ] **Final Verification**: Perform a final check of all changes, run
  `./scripts/check_before_commit.sh`, and ensure all CI checks pass.

- [x] **Custom Lint Package**: Custom lint package implementation moved to separate Jira
  ticket [MEM-115](https://anirac-tech.atlassian.net/browse/MEM-115) and removed from this branch as
  out of scope.

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