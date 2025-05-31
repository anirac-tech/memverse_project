# JIRA Story: Advanced BDD Tests with Patrol Integration

## Story Overview

**Title**: Implement BDD Tests with Patrol for Native Platform Testing and Enhanced Coverage
**Type**: Task  
**Priority**: Medium
**Estimate**: 13 Story Points
**Dependencies**: Complete basic BDD widget tests first

## User Story

As a developer, I want to enhance BDD tests with Patrol integration so that I can test native
platform interactions, achieve higher test coverage (80-90%), and create more reliable tests with
real device interactions and visual validation.

## Acceptance Criteria

### Must Have

- [ ] **Patrol Integration**: Configure `patrol` CLI with `bdd_widget_test`
- [ ] **Native Platform Testing**: Test real device interactions, permissions, native keyboard
- [ ] **Enhanced Coverage**: Achieve 80-90% test coverage with real user flows
- [ ] **Recording Capability**: Use Patrol's recording feature to generate step definitions
- [ ] **Screenshot Validation**: Capture screenshots for visual regression testing
- [ ] **Real Network Testing**: Test with actual API calls, not mocked responses
- [ ] **Environment Setup**: Configure for both Android and iOS platforms

### Should Have

- [ ] **Test Recording Automation**: Script to record user interactions and convert to BDD steps
- [ ] **Visual Comparison**: Golden screenshot comparisons for UI validation
- [ ] **Platform-Specific Tests**: iOS and Android specific behavior testing
- [ ] **Deep Link Testing**: Test app launch via deep links and external triggers
- [ ] **Performance Validation**: Test real device performance characteristics

### Could Have

- [ ] **CI/CD Integration**: Automated Patrol test execution in GitHub Actions
- [ ] **Test Reports**: Enhanced reporting with screenshots and performance metrics
- [ ] **Multi-Device Testing**: Test across different device configurations
- [ ] **Network Condition Testing**: Test with various network conditions

## Technical Requirements

### Dependencies to Add

```yaml
dev_dependencies:
  patrol: ^3.6.1
  bdd_widget_test: ^1.6.1
  build_runner: ^2.4.12
```

### Project Configuration Files

1. `patrol.yaml` - Platform configuration
   ```yaml
   android:
     package_name: com.spiritflightapps.memverse
   ios:
     bundle_id: com.spiritflightapps.memverse
   targets:
     - integration_test
   ```

2. Enhanced `build.yaml` for Patrol + BDD integration

### Enhanced Feature Files

1. `integration_test/patrol_authentication.feature` - Native login flows
2. `integration_test/patrol_verse_practice.feature` - Real keyboard interactions
3. `integration_test/patrol_platform_features.feature` - Platform-specific testing
4. `integration_test/patrol_deep_links.feature` - External app triggers

### Advanced Step Definitions

- `i_launch_app_from_home_screen.dart` - Native app launching
- `i_handle_native_permission_dialogs.dart` - Platform permissions
- `i_enter_text_with_native_keyboard.dart` - Real keyboard input
- `i_capture_screenshot_state.dart` - Visual validation
- `i_perform_real_network_login.dart` - Actual API authentication

## Implementation Tasks

### Phase 1: Patrol Setup and Configuration (3 points)

- [ ] Install Patrol CLI globally
- [ ] Add Patrol dependencies to project
- [ ] Create `patrol.yaml` configuration
- [ ] Update `build.yaml` for Patrol integration
- [ ] Verify setup with `patrol doctor`

### Phase 2: Recording and Step Generation (4 points)

- [ ] Record authentication flow with `patrol develop`
- [ ] Record verse practice interactions
- [ ] Record UI navigation patterns
- [ ] Convert recordings to BDD step definitions
- [ ] Implement PatrolTester-based steps

### Phase 3: Native Platform Testing (3 points)

- [ ] Implement native app launch steps
- [ ] Add permission dialog handling
- [ ] Create real keyboard interaction steps
- [ ] Add platform-specific behavior tests
- [ ] Implement deep link testing

### Phase 4: Visual and Performance Validation (2 points)

- [ ] Add screenshot capture to key test states
- [ ] Implement visual comparison logic
- [ ] Add performance timing validation
- [ ] Create golden screenshot baseline

### Phase 5: Integration and Automation (1 point)

- [ ] Create automated test runner script
- [ ] Generate enhanced coverage reports
- [ ] Validate 80-90% coverage target
- [ ] Document Patrol-specific testing approach

## Enhanced Test Scenarios

### Native Authentication Flow

```gherkin
Feature: Native Authentication with Platform Features
  Scenario: Login with native keyboard and permissions
    Given the app is launched from home screen
    When I tap the username field
    And I enter credentials using native keyboard
    And I handle any permission dialogs
    And I tap login button
    Then I should see the main screen
    And the app should request notification permissions
    And I capture screenshot 'login_success_state'
```

### Real Network Testing

```gherkin
Feature: Real Network Interactions
  Scenario: Authentication with actual API calls
    Given the app has network connectivity
    When I perform real network login
    And I wait for actual server response
    Then I should see authenticated state
    And the session should persist across app restarts
```

### Platform-Specific Behaviors

```gherkin
Feature: Platform-Specific Testing
  Scenario: Android back button handling
    Given I am on the verse practice screen
    When I press the Android back button
    Then I should return to login screen
    
  Scenario: iOS swipe navigation
    Given I am on the main screen
    When I perform iOS swipe gesture
    Then I should see navigation response
```

## Environment and Infrastructure

### Required Tools

```bash
# Install Patrol CLI
dart pub global activate patrol_cli

# Verify installation
patrol --version
patrol doctor
```

### Test Execution Commands

```bash
# Record user interactions
patrol develop --target integration_test/record_session.dart

# Generate BDD test files with Patrol support
dart run build_runner build --delete-conflicting-outputs

# Run Patrol BDD tests
patrol test --reporter expanded

# Generate coverage with Patrol
patrol test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Device Configuration

- **Android**: Physical device or emulator with API level 21+
- **iOS**: Simulator or physical device with iOS 11+
- **Permissions**: Camera, microphone, notifications as needed
- **Network**: Real internet connection for API testing

## Advanced Capabilities

### Recording-Driven Development

1. **Record Real Interactions**: Use `patrol develop` to record actual user flows
2. **Auto-Generate Steps**: Convert recordings to BDD step definitions
3. **Enhance with Logic**: Add assertions and validations to recorded steps
4. **Replay with Variations**: Run same flow with different data

### Visual Validation Pipeline

1. **Capture Screenshots**: At key test states for visual validation
2. **Golden File Comparison**: Compare against baseline screenshots
3. **Visual Regression Detection**: Catch UI changes between releases
4. **Multi-Resolution Testing**: Test across different screen sizes

### Performance Integration

1. **Real Device Performance**: Measure actual app performance during tests
2. **Network Timing**: Validate API response times
3. **UI Responsiveness**: Ensure smooth animations and transitions
4. **Memory Usage**: Monitor memory consumption during test flows

## Success Criteria

### Definition of Done

- [ ] Patrol CLI setup and `patrol doctor` passes
- [ ] All Patrol BDD feature files execute successfully
- [ ] Test coverage between 80-90% (higher than widget-only tests)
- [ ] Screenshots captured and visual validation working
- [ ] Real network authentication testing passes
- [ ] Platform-specific behaviors validated on both iOS and Android
- [ ] Performance metrics within acceptable ranges
- [ ] Documentation updated with Patrol testing procedures

### Enhanced Verification Steps

1. **Patrol Setup**: `patrol doctor` shows all systems operational
2. **Recording Works**: `patrol develop` successfully records interactions
3. **Test Execution**: `patrol test` runs all scenarios without failures
4. **Coverage Improvement**: Coverage higher than basic BDD widget tests
5. **Visual Validation**: Screenshots captured and comparison working
6. **Cross-Platform**: Tests pass on both Android and iOS
7. **Real Network**: Authentication works with actual API calls

## Risk Assessment

### High Risk

- **Device Dependencies**: Tests require specific device configurations
- **Network Dependencies**: Real network calls may be unreliable in CI/CD
- **Platform Differences**: iOS and Android behavior variations
- **Recording Complexity**: Converting recordings to maintainable steps

### Mitigation Strategies

- Provide fallback mock responses for network failures
- Test on multiple device configurations
- Add platform detection and conditional logic
- Create both recorded and hand-written step definitions
- Implement retry logic for flaky native interactions

## Advanced Coverage Expectations

### Coverage Improvements vs Basic BDD

- **Basic BDD Widget Tests**: 75-85% coverage
- **Patrol Enhanced Tests**: 80-90% coverage
- **Additional Coverage Areas**:
    - Native platform interactions
    - Real network call paths
    - Device-specific behavior handling
    - Permission dialog flows
    - Deep link processing

### Why Higher Coverage with Patrol

1. **Real User Flows**: Tests actual user interactions, not just widget behavior
2. **Native Platform Code**: Covers platform-specific implementations
3. **Network Integration**: Tests actual API integration code paths
4. **Error Handling**: Catches real-world error scenarios
5. **Performance Code**: Tests code that only executes under real conditions

## Resources and References

### Documentation Dependencies

- `bdd_on_rails.md` - Complete Patrol + BDD integration guide
- `live_integration_tests_exceptions.md` - Understanding coverage limitations
- Patrol CLI documentation and examples

### Technical Dependencies

- Completed basic BDD widget test story
- Patrol CLI installed and configured
- Physical devices or reliable emulators
- Network access for real API testing

## Notes

This story builds upon the basic BDD widget testing foundation to provide comprehensive, real-world
testing capabilities. The higher story point estimate reflects the additional complexity of native
platform integration, recording workflows, and cross-platform testing requirements.

The coverage improvement from 75-85% to 80-90% represents testing additional code paths that are
only exercised during real device interactions and actual network operations.