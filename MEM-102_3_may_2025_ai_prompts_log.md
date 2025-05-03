# AI Prompts Log - MEM-102 - May 3, 2025

## AI Model Information

- **Model**: Claude-3.7 Sonnet (Anthropic)
- **Key Capabilities**:
    - Code generation and modification
    - Complex reasoning about software architecture
    - Contextual understanding of large codebases
    - Understanding of Flutter and Dart best practices

## Summary

This log contains the interaction with the AI assistant (Claude-3.7 Sonnet) while implementing
logging standards using AppLogger and creating documentation for app flavors in the Memverse
project.

## Interactions

### 2025-05-03 09:45:00 AM - Fix Missing AppLogger Imports

**User Prompt**: add missing imports fo appLogger

**AI Response Summary**:

- Examined the AppLogger.dart file and its implementation
- Found AppLogger usage in feedback_service.dart
- Fixed the import issue in feedback_service.dart
- Added import for `package:logger/logger.dart`

### 2025-05-03 09:48:00 AM - Clarification on AppLogger Usage

**User Prompt**: no, you're confused, add the applogger import to the places applogger is called
please

**AI Response Summary**:

- Clarified that the AppLogger import was already present:
  `import 'package:memverse/src/utils/app_logger.dart';`
- Asked for clarification on which files needed AppLogger imports

### 2025-05-03 09:52:00 AM - Fix AppLogger Implementation and Add StackTrace

**User Prompt**: make sure it compiles, add missing imports and add stacktrace to the signature and
usage for the thin applogger.e wrapper

**AI Response Summary**:

- Fixed missing parentheses in AppLogger calls
- Added proper stackTrace parameters to AppLogger.e calls
- Fixed syntax issues related to AppLogger calls
- Updated AppLogger.e to include error objects and stack traces
- Ran dart fix --apply to ensure all issues were fixed
- Ran flutter analyze to verify the code compiles without errors

### 2025-05-03 09:58:00 AM - Add Logging Standards to Pre-commit Hook and CI Pipeline

**User Prompt**: add something to the firebender rules and at the to of the pre commit script so
that " debugPrint" or " log(" is not used anywhere in the project but instead user AppLogger.d( or
AppLogger.e as appropriate. Also add a mention in the readme about this and the contributing.md doc.
Also update contributing.md with instructions on setting up the precommit hook. Also make a task in
in the main.yaml pipeline where it fails the pipeline if there are any debugPrint( or log( usages,
there should be only AppLogger.

**AI Response Summary**:

- Added checks in the pre-commit script to detect and prevent debugPrint and log usage
- Updated GitHub workflow (main.yaml) to include a job checking for prohibited logging methods
- Created and updated README.md section about logging standards
- Updated CONTRIBUTING.md with instructions for setting up pre-commit hooks and logging guidelines

### 2025-05-03 10:02:00 AM - Update README.md

**User Prompt**: please make sure readme.md contains the information in the very first commit of the
readme.md such as how to run it and what localization is about, then add a link to contrivbuting.md

**AI Response Summary**:

- Updated README.md to include comprehensive information from the first commit
- Added sections on how to run the app with different flavors
- Added information about internationalization
- Added a link to CONTRIBUTING.md for development guidelines

### 2025-05-03 10:05:00 AM - Add More Details to README.md

**User Prompt**: let's add to the readme.md the full run command like in setup.md as well as a
little informtaion on the purpose of flavors

**AI Response Summary**:

- Added detailed information about flavors in README.md
- Included the full run command with environment variables
- Added explanations of development, staging, and production flavors
- Referenced setup.md for detailed environment variable setup

### 2025-05-03 10:08:00 AM - Add MIT License

**User Prompt**: if mit licensse is mentioned in the top of the readme as mit license then there
should be a license file for mit license

**AI Response Summary**:

- Created a standard MIT LICENSE file in the repository root
- Set copyright to "2023-present Memverse Contributors"
- Included the full standard MIT license text

### 2025-05-03 10:10:00 AM - Create App Flavors Documentation

**User Prompt**: please add a flavors_info_for_users md and flavor_info_for_devs md explaining the
purpose of flavors from a team, user and developer perspective such as dev and staging are preprod
and limited distribution and can contain bugsee and more debugging, production is for full play and
app store releases, etc, and also info on what kDebugMode is in the for devs file, how the applogger
uses it, etc, and reference the flavors info files in the readme and reference the flavors info for
devs one in contributing.md

**AI Response Summary**:

- Created flavors_info_for_users.md with user-friendly explanations of app flavors
- Created flavor_info_for_devs.md with technical implementation details
- Added information about how each flavor works and their visual differences
- Included details on kDebugMode and how AppLogger uses it
- Added external links to Flutter documentation, Code with Andrea, and Very Good Ventures
- Updated references to these files in README.md and CONTRIBUTING.md

### 2025-05-03 10:15:00 AM - Update Pull Request Template

**User Prompt**: please change the pull request template to reflect differences from main that have
been done in this branch but with checkboxes for testign the script and the pipeline with both types
of invalid logging and a reference to https://anirac-tech.atlassian.net/browse/MEM-112 as well as
MEM-102 since both are in this PR

**AI Response Summary**:

- Updated the PR template to reference MEM-112 and MEM-102 JIRA tickets
- Added a comprehensive testing checklist including:
    - Verifying AppLogger functionality
    - Testing pre-commit hooks catch prohibited logging methods
    - Confirming CI pipeline fails when prohibited methods are used
- Listed all documentation added/updated
- Provided a clear summary of changes related to AppLogger implementation and flavor documentation

### 2025-05-03 10:17:16 AM - Create AI Prompts Log

**User Prompt**: can you add a mem-102_3_may_2025_ai_prompts_log file with a record of today's
prompts with timestamps with a summary of your responses please

**AI Response Summary**:

- Created MEM-102_3_may_2025_ai_prompts_log.md with chronological record of interactions
- Included timestamps, user prompts, and summaries of AI responses
- Organized the log with clear sections and headers for readability

### 2025-05-03 10:19:00 AM - Clean Up Temporary Files

**User Prompt**: there should be no flavor-section-txt, everything shoudl be in reasonably liinked
md files

**AI Response Summary**:

- Checked for and found a temporary file called flavor-section.txt
- Removed the unnecessary temporary file
- Verified that only proper Markdown documentation files remain
- Confirmed that all documentation is properly linked between files

### 2025-05-03 10:21:42 AM - Update Log and Create Lint Rule for Logging

**User Prompt**: first add this interaction nd the last few to the prompts log then please take an
initial try at creating a custom lint rule that will provide a flutter analyze error and quickfix
for the things we've done abotu debugPrint and log( to AppLogger

**AI Response Summary**:

- Updated the AI prompts log with recent interactions
- Created a custom lint rule to detect prohibited logging methods
- Implemented a quick fix suggestion to replace debugPrint and log with appropriate AppLogger
  methods
- Provided instructions for integrating the custom lint rule into the project

### 2025-05-03 10:26:58 AM - Create Detailed Logging Documentation and Continue Lint Rule Development

**User Prompt**: please keep goign with last request then please include a logging md that is linked
in contributing.md with info on the quickfix, lint error, pipelien and commit script about this,
also make sure the prompts file is updated

**AI Response Summary**:

- Created a complete custom lint package called `memverse_lints` with:
    - Rules to detect and fix `debugPrint()` and `log()` calls
    - Quick fixes to automatically convert to `AppLogger` calls
    - Setup script to integrate with the main project
    - Tests to verify the rules work correctly
- Created comprehensive `logging.md` documentation with:
    - AppLogger overview and usage examples
    - Details on all logging methods
    - Information about enforcement tools (pre-commit hook, CI checks, lint rules)
    - Examples of quick fixes
- Updated CONTRIBUTING.md to link to the new logging documentation
- Updated the AI prompts log with all interactions

### 2025-05-03 11:24:53 AM - Testing Lint Rules and Creating PWA Documentation

**User Prompt**: Please keep going on the last request but also make a pwa_user and a pwa_technical
md files that describe how the netlify preview works on the mr (fro the technical one mosty) and how
to use a pwa with add to home etc. In particular the one for user should be simple - including not
use the words PWA in the content directly but just at the very bottom for helpful links or appendix
or similar. Also create a demo_pwa md file wiht instructions onhow to create a demo of the pwa
feature for users that are very non-technical, just ordinary users (ios and android) who have never
heard of pwas, possibly with loom

**AI Response Summary**:

- Created a test file with prohibited logging methods and tested the detection
- Modified the custom lint package to handle dependency conflicts
- Demonstrated that the grep-based detection in the pre-commit hook works correctly
- Created three comprehensive PWA documentation files:
    - **pwa_user.md**: User-friendly guide for installing the app on home screen, avoiding technical
      terms
    - **pwa_technical.md**: Technical documentation about PWA implementation and Netlify preview
      process
    - **demo_pwa.md**: Instructions for creating demonstration videos showing the installation
      process
- Each documentation file includes:
    - Clear step-by-step instructions
    - Platform-specific guidance (iOS, Android, desktop)
    - Visual aids and examples
    - Best practices for the target audience

### 2025-05-03 11:52:29 AM - Fixing Formatting Issues and Creating Question Documents

**User Prompt**: finish last request, then try to fix this _- Run dart format --output=none
--set-exit-if-changed . Changed lib/l10n/arb/app_localizations.dart Formatted 91 files (1 changed)
in 1.03 seconds. -- in the github pipeline, if you can't fix this please comment out the format task
in the pipeline. Search web for recent controvery about trailing comma if needed with dart format
and/or ignore trailing comma in app localizations and or disable in analysis options yaml

**AI Response Summary**:

- Investigated the formatting issue with app_localizations.dart related to trailing commas
- Researched Dart's handling of trailing commas in the formatter
- Created a fix_generated_localizations.sh script to automatically fix trailing comma issues
- Updated the GitHub workflow to run the script before format checking
- Modified analysis_options.yaml to exclude the generated file from analysis
- Created two question documents for different developer experience levels:
    - questions-L1.md: Beginner-friendly questions about the codebase
    - questions-L2.md: Advanced questions requiring senior developer input
- Fixed several issues with dart fix --apply
- Noted remaining dependency conflicts between memverse_lints and riverpod_generator that would need
  further resolution