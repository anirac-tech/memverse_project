# Files That Should Maybe Be Removed

## Overview

This document identifies files that may no longer be needed once the JIRA stories in the
`jira_stories_to_do_soon/` directory are completed. These files represent duplicated functionality,
outdated approaches, or temporary implementations that will be superseded by the new BDD and Maestro
testing infrastructure.

## Files to Consider for Removal

### 1. Temporary Test Implementation Files

#### Border Color Test Files

**Location**: `test/` directory
**Files**:

- `green_border.dart` - Temporary implementation for correct answer styling
- `orange_border.dart` - Temporary implementation for almost-correct answer styling

**Reasoning**: These files likely contain hardcoded color validation logic that will be replaced by
the parameterized BDD step definitions like `I should see input field color {Colors.green}` and
`I should see input field color {Colors.orange}`.

**Replacement**: BDD step definitions in `integration_test/step/i_should_see_input_field_color.dart`

#### Temporary Integration Test Files

**Location**: `integration_test/` directory  
**Files**:

- `high_coverage_integration_test.dart` - Manual integration test implementation

**Reasoning**: This file contains manually written integration tests that will be superseded by the
generated BDD test files with better coverage and maintainability.

**Replacement**: Generated BDD test files from `*.feature` files

### 2. Outdated Widget Test Files

#### Manual Widget Tests

**Location**: `test/` directory
**Files**:

- `memverse_page_edge_cases_test.dart` - Manual edge case testing
- `question_section_test.dart` - Specific widget testing that may be covered by BDD
- `stats_history_section_test.dart` - Specific section testing

**Reasoning**: These files may contain overlapping test coverage with the new BDD tests. Should be
evaluated for shared code extraction rather than complete removal.

**Action**: Analyze for shared test utilities and refactor before removal

### 3. Temporary Documentation Files

#### Experimental Documentation

**Location**: Root directory
**Files**:

- `temporarily_ditl.md` - Temporary DITL tracking file
- `next_llm_prompt.txt` - Session-specific prompt file
- `olexa_bdd_next_steps.md` - Implementation guide (becomes permanent docs)

**Reasoning**: These were created for specific implementation phases and may not be needed
long-term.

**Action**: Archive useful content into permanent documentation before removal

### 4. Duplicate Test Utilities

#### Color Validation Utilities

**Location**: `test/` directory
**Files**:

- Any files containing duplicate color validation logic
- Temporary widget finder utilities that are now in BDD steps

**Reasoning**: BDD step definitions will provide standardized color validation and widget
interaction utilities.

**Replacement**: Shared test utilities extracted from BDD implementation

### 5. Old Integration Test Approaches

#### Legacy Integration Files

**Location**: `integration_test/` directory
**Files**:

- `comprehensive_app_test.dart` - May be superseded by BDD comprehensive tests
- `abbreviations_integration_test.dart` - Specific feature tests that may be covered

**Reasoning**: BDD approach provides better structure and maintainability for comprehensive testing.

**Action**: Extract any unique test cases not covered by BDD scenarios

## Files to Keep and Refactor

### Shared Test Utilities (Keep)

**Location**: `test/helpers/` directory
**Files**:

- `test_helpers.dart` - Shared utilities for both widget and integration tests
- `mock_*.dart` - Mock implementations for widget tests

**Reasoning**: These provide shared functionality between widget tests (with mocks) and integration
tests (live).

### Core Widget Tests (Keep but Refactor)

**Location**: `test/src/` directory
**Files**: Widget-specific tests that focus on isolated component behavior

**Action**: Refactor to use shared test utilities while maintaining widget-specific mocking

### Live Integration Tests (Keep)

**Location**: `integration_test/` directory  
**Files**:

- `live_login_test.dart` - Live API testing
- `feedback_test.dart` - Real feedback integration

**Reasoning**: These test actual external integrations that BDD tests may not cover.

## Analysis Before Removal

### Step 1: Coverage Analysis

Before removing any files, run coverage analysis to ensure no unique test cases are lost:

```bash
# Current coverage with existing tests
flutter test --coverage
genhtml coverage/lcov.info -o coverage/old_coverage

# Coverage after BDD implementation
flutter test integration_test/ --coverage  
genhtml coverage/lcov.info -o coverage/new_coverage

# Compare coverage reports
diff -r coverage/old_coverage coverage/new_coverage
```

### Step 2: Shared Code Extraction

Extract shared test utilities before removing files:

```dart
// test/shared/test_utilities.dart
class SharedTestUtilities {
  static Future<void> loginWithCredentials(WidgetTester tester) {
    // Shared logic for both widget and integration tests
  }
  
  static void validateInputFieldColor(Color expectedColor) {
    // Shared color validation logic
  }
}
```

### Step 3: Test Case Migration

Ensure all unique test cases are migrated to BDD scenarios:

```gherkin
# Any unique scenarios from removed files should become BDD scenarios
Feature: Edge Cases from Removed Tests
  Scenario: Specific edge case that was in removed file
    Given specific conditions
    When specific action
    Then specific validation
```

## Removal Prioritization

### High Priority (Remove First)

1. **Temporary color validation files** - Clearly superseded by BDD steps
2. **Manual integration test files** - Replaced by BDD-generated tests
3. **Temporary documentation** - Archive and remove session-specific files

### Medium Priority (Analyze First)

1. **Overlapping widget tests** - Extract shared code, then remove duplicates
2. **Legacy integration approaches** - Ensure no unique coverage is lost
3. **Experimental implementations** - Keep any proven approaches

### Low Priority (Keep for Now)

1. **Live API integration tests** - May not be covered by BDD
2. **Performance-specific tests** - Different purpose than BDD functional tests
3. **Platform-specific tests** - May require separate test approach

## Shared Code Opportunities

### Test Data Setup

```dart
// test/shared/test_data.dart
class TestData {
  static const correctVerseReferences = {
    'He is before all things': 'Col 1:17',
    'It is for freedom': 'Gal 5:1',
  };
  
  static const almostCorrectScenarios = {
    'Gal 5:1': 'Gal 5:2', // Expected vs Input
  };
}
```

### Widget Interaction Helpers

```dart
// test/shared/widget_helpers.dart
class WidgetHelpers {
  // Used by both widget tests (with mocks) and integration tests (live)
  static Future<void> enterCredentials(
    WidgetTester tester, {
    required String username,
    required String password,
    bool useMocks = false,
  }) async {
    if (useMocks) {
      // Setup mocks for widget tests
    }
    // Common interaction logic
  }
}
```

## Post-Removal Validation

### Ensure No Regression

```bash
# All tests should still pass after file removal
flutter test
flutter test integration_test/

# Coverage should be maintained or improved
flutter test --coverage
lcov --summary coverage/lcov.info
```

### Documentation Update

- Update README.md to reflect new testing approach
- Remove references to deleted files from documentation
- Update CI/CD workflows to use new test structure

## Notes

The goal is to eliminate duplication while preserving unique test coverage. The new BDD approach
should provide better structure and maintainability, but we must ensure no valid test cases are lost
in the transition.

Files should be removed incrementally with validation at each step to ensure the testing
infrastructure remains robust throughout the transition.