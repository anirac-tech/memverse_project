# JIRA Story: Implement BDD Widget Tests for Core App Coverage

## Story Overview

**Title**: Implement BDD Widget Tests with High Coverage Excluding Bootstrap Code
**Type**: Task
**Priority**: High
**Estimate**: 8 Story Points

## User Story

As a developer, I want to implement BDD widget tests for the Memverse app so that I can achieve high
test coverage (75-85%) with readable, maintainable test scenarios while excluding untestable code
areas.

## Acceptance Criteria

### Must Have

- [ ] **BDD Framework Setup**: Configure `bdd_widget_test` package with `build_runner`
- [ ] **Feature Files Created**: Authentication, verse practice, and UI navigation scenarios
- [ ] **Step Definitions Implemented**: Custom steps for app-specific interactions
- [ ] **Environment Variables**: Support for test credentials via env vars
- [ ] **Coverage Target**: Achieve 75-85% test coverage
- [ ] **Bootstrap Exclusions**: Properly exclude `bootstrap.dart` and other untestable code
- [ ] **Test Execution**: All BDD tests pass with `flutter test integration_test/`

### Should Have

- [ ] **Parameterized Steps**: Reusable steps like `I should see input field color {Colors.green}`
- [ ] **Error Handling**: Tests for validation errors and empty field scenarios
- [ ] **Build Configuration**: Proper `build.yaml` with external steps configuration
- [ ] **Documentation**: Updated README with BDD test execution instructions

### Could Have

- [ ] **Visual Validation**: Screenshot capture for key test states
- [ ] **Test Reports**: HTML coverage reports generation
- [ ] **CI Integration**: GitHub Actions workflow for automated BDD testing

## Technical Requirements

### Dependencies to Add

```yaml
dev_dependencies:
  bdd_widget_test: ^1.6.1
  build_runner: ^2.4.12
```

### Feature Files to Create

1. `integration_test/authentication_bdd_test.feature` - Login/logout flows
2. `integration_test/verse_practice_bdd_test.feature` - Verse reference testing
3. `integration_test/app_ui_bdd_test.feature` - UI elements and navigation
4. `integration_test/hello_world_bdd_test.feature` - Basic proof of concept

### Step Definitions Required

- `the_app_is_running.dart` - App initialization
- `i_am_logged_in_as_test_user.dart` - Authentication with env vars
- `i_enter_into_reference_input_field.dart` - Verse input
- `i_should_see_input_field_color.dart` - Color validation
- `i_see_verse_text.dart` - Generic verse content validation

### Coverage Exclusions

Based on `live_integration_tests_exceptions.md`, exclude these areas:

- `lib/src/bootstrap.dart` - App initialization code
- `lib/main_*.dart` - Entry point files
- Platform-specific directories (`android/`, `ios/`)
- Debug code blocks (marked with `// coverage:ignore`)
- Build configuration files

## Implementation Tasks

### Phase 1: Setup and Configuration (2 points)

- [ ] Add BDD dependencies to `pubspec.yaml`
- [ ] Create `build.yaml` configuration
- [ ] Set up project structure for BDD tests

### Phase 2: Feature Files Creation (2 points)

- [ ] Write authentication feature scenarios
- [ ] Write verse practice feature scenarios
- [ ] Write UI navigation feature scenarios
- [ ] Create hello world proof of concept

### Phase 3: Step Definitions (3 points)

- [ ] Implement app launch step
- [ ] Implement authentication steps with env vars
- [ ] Implement verse input and validation steps
- [ ] Implement UI interaction steps
- [ ] Add parameterized color validation

### Phase 4: Testing and Coverage (1 point)

- [ ] Run `dart run build_runner build`
- [ ] Execute all BDD tests
- [ ] Generate coverage report
- [ ] Validate 75-85% coverage target
- [ ] Document exclusions and rationale

## Test Scenarios

### Authentication Scenarios

```gherkin
Feature: User Authentication BDD Tests

  Scenario: Successful login with valid credentials
    Given the app is running
    When I enter test credentials into login fields
    And I tap login button
    Then I see {'Memverse Reference Test'} text
```

### Verse Practice Scenarios

```gherkin
Feature: Verse Reference Practice BDD Tests

  Scenario: Correct verse reference provides feedback
    Given I see verse text
    When I enter {'Col 1:17'} into reference input field
    And I tap submit button
    Then I should see input field color {Colors.green}
```

## Environment Setup

### Required Environment Variables

```bash
export MEMVERSE_USERNAME="test_username"
export MEMVERSE_PASSWORD="test_password"
export MEMVERSE_CLIENT_ID="test_client_id"
```

### Test Execution Commands

```bash
# Generate BDD test files
dart run build_runner build --delete-conflicting-outputs

# Run all BDD tests
flutter test integration_test/ --reporter expanded

# Generate coverage report
flutter test --coverage integration_test/
genhtml coverage/lcov.info -o coverage/html
```

## Success Criteria

### Definition of Done

- [ ] All BDD feature files execute successfully
- [ ] Test coverage between 75-85% (excluding bootstrap and untestable code)
- [ ] All step definitions implemented with proper error handling
- [ ] Environment variables properly configured for credentials
- [ ] Documentation updated with BDD test instructions
- [ ] Coverage report generated and exclusions documented

### Verification Steps

1. **Setup Verification**: `dart run build_runner build` completes without errors
2. **Test Execution**: All BDD scenarios pass without failures
3. **Coverage Check**: `lcov --summary coverage/lcov.info` shows target range
4. **Environment Test**: Tests work with different credential sets
5. **Documentation**: README includes clear BDD test instructions

## Risk Assessment

### High Risk

- **Widget Key Dependencies**: Tests depend on specific widget keys existing
- **Async Timing**: Login and verse submission timing may cause flaky tests
- **Environment Variables**: Missing credentials will cause test failures

### Mitigation Strategies

- Add fallback widget finders (by type, by text)
- Include proper `pumpAndSettle()` calls with timeouts
- Provide default test credentials for local development
- Add debug logging to step definitions

## Resources

### Documentation References

- `olexa_bdd_widget_test_steps.md` - Complete implementation guide
- `live_integration_tests_exceptions.md` - Coverage exclusions
- `next_llm_prompt.txt` - Technical implementation details

### Testing Strategy

- Focus on happy path scenarios first
- Add error handling scenarios second
- Exclude untestable code areas per exceptions document
- Target realistic coverage expectations (75-85%)

## Notes

This story focuses on traditional BDD widget testing without Patrol integration. For native platform
testing and advanced capabilities, see the separate Patrol BDD story.

The coverage target of 75-85% is realistic for this simple app when excluding bootstrap code,
platform-specific implementations, and extreme error conditions as documented in the exceptions
file.