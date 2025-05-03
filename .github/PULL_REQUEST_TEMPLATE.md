<!--
  Thanks for contributing!

  Provide a description of your changes below and a general summary in the title
-->

## Description

# Implement AppLogger, Enforce Logging Standards, and Add Documentation

## Jira Tickets

- [MEM-112](https://anirac-tech.atlassian.net/browse/MEM-112): Implement logging standards and
  AppLogger
- [MEM-102](https://anirac-tech.atlassian.net/browse/MEM-102): Documentation for app flavors

## Changes vs. Origin/Main

This branch introduces several key changes compared to the main branch:

- **Standardized Logging**: Implemented `AppLogger` utility and updated existing code (e.g.,
  `feedback_service.dart`) to use it.
- **Logging Enforcement**:
    - Added checks to `scripts/check_before_commit.sh` to prevent `debugPrint` and `log`.
    - Added a new `check-logging-standards` job to the CI pipeline (`.github/workflows/main.yaml`).
- **Custom Lint Rules (Experimental)**: Added a `memverse_lints` package with rules and quick fixes
  for logging (currently facing dependency issues).
- **CI Fixes**:
    - Implemented `scripts/fix_generated_localizations.sh` to handle formatting issues in generated
      localization files.
    - Updated CI workflow to run this script before the format check.
    - Excluded `app_localizations.dart` from analysis in `analysis_options.yaml`.
- **Comprehensive Documentation**: Added several new documentation files:
    - `logging.md` (explaining AppLogger and enforcement)
    - `flavors_info_for_users.md` & `flavor_info_for_devs.md` (explaining flavors)
    - `pwa_user.md`, `pwa_technical.md`, `demo_pwa.md` (PWA details)
    - `questions-L1.md` & `questions-L2.md` (codebase questions)
    - `gemini2.5pro_review.md` (AI review summary)
    - `summary.md` (summary of branch changes)
    - `LICENSE` (MIT License file)
- **Documentation Updates**:
    - Updated `README.md` with sections on running the app, flavors, logging, and contributing.
    - Updated `CONTRIBUTING.md` with details on pre-commit hooks, logging standards, custom lints,
      and
      flavors.
    - Updated `.github/cspell.json` with new technical terms.
- **AI Interaction Log**: Created and maintained `MEM-102_3_may_2025_ai_prompts_log.md`.

## Testing Checklist

- [ ] Verified AppLogger properly logs in debug mode only
- [ ] Tested pre-commit hook catches invalid logging:
    - [ ] Tested with `debugPrint()` usage
    - [ ] Tested with `log()` usage
- [ ] Confirmed CI pipeline fails when prohibited logging methods are used
- [ ] Confirmed CI formatting check passes after running `fix_generated_localizations.sh`
- [ ] Confirmed all new/updated documentation renders correctly and links are valid
- [ ] (If Lint Package Enabled) Verified custom lint rules flag errors and quick fixes work in IDE

## Outstanding Issues / Next Steps

- Resolve dependency conflicts for the `memverse_lints` package or disable it.
- Investigate a potentially more robust fix for localization file formatting.
- Address any specific CodeRabbit / manual review comments.