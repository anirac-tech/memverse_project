<!--
  Thanks for contributing!

  Provide a description of your changes below and a general summary in the title

-->

## Description

# Fix Workflow and Test Coverage Issues

## Changes

This PR adds comprehensive golden test infrastructure to the Memverse app to facilitate visual
regression testing and ensure UI consistency.

### Features Added

- **Visual Regression Testing**: Added golden tests for key UI components
- **Documentation**: Created `FEATURES.md` to track app features and their test coverage
- **GitHub Workflow**: Separate workflow for golden tests that doesn't fail builds on UI changes
- **Pre-commit Hook**: Updated to handle golden tests without failing commits
- **Utility Scripts**:
    - `update_golden_files.sh`: Generate/update golden images
    - `generate_golden_report.sh`: Create visual reports for reviewing differences
    - `setup_git_hooks.sh`: Configure Git hooks for the project

### Technical Details

- Golden tests are tagged with `golden` and can be run separately
- Directory structure organized with `goldens` folders next to test files
- HTML reports generated for visual comparison of UI changes
- BDD-style test structure for better readability
- Integration with existing CI/CD infrastructure

## Testing Done

- Created initial golden tests for LoginPage and MemversePage
- Tested pre-commit hooks with golden test differences
- Verified golden test reports generation
- Coverage improvements in both widget and integration tests

## Screenshots

(N/A - Golden tests themselves serve as visual documentation)