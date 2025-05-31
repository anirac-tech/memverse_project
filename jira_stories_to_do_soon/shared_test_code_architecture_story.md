# JIRA Story: Shared Test Code Architecture for Widget and Integration Tests

## Story Overview

**Title**: Refactor Test Architecture to Share Code Between Widget Tests (Mocked) and Integration
Tests (Live)
**Type**: Technical Debt / Refactoring
**Priority**: Medium
**Estimate**: 8 Story Points
**Dependencies**: BDD widget tests completed

## User Story

As a developer, I want to refactor the test architecture to share common code between widget tests
and integration tests so that widget tests can achieve 100% coverage with mocks while integration
tests remain simpler with live data, reducing code duplication and maintenance overhead.

## Problem Statement

Currently, there is duplication between widget tests and integration tests:

- **Widget Tests**: Use mocks, more complex setup, should achieve 100% coverage
- **Integration Tests**: Use live data, simpler setup, achieve 75-85% coverage
- **Duplication**: Both implement similar test logic for login, verse practice, UI interactions

## Solution Architecture

### Shared Code Structure

```
test/
├── shared/
│   ├── test_utilities.dart        # Common test utilities
│   ├── test_data.dart             # Shared test data constants
│   ├── widget_helpers.dart        # Reusable widget interaction helpers
│   └── validation_helpers.dart    # Shared validation logic
├── widget_tests/                  # Widget tests with mocks (100% coverage goal)
├── mocks/                         # Mock implementations
└── helpers/                       # Widget-specific test helpers

integration_test/
├── *.feature                      # BDD feature files (live data)
├── step/                          # BDD step definitions (live data)
└── shared/                        # Integration-specific utilities
```

## Acceptance Criteria

### Must Have

- [ ] **Shared Test Utilities**: Common code extracted for reuse between widget and integration
  tests
- [ ] **Widget Test Enhancement**: Widget tests achieve 100% coverage using mocks
- [ ] **Integration Test Simplification**: Integration tests use live data with minimal setup
- [ ] **Code Deduplication**: Eliminate duplicate test logic across test types
- [ ] **Consistent Test Data**: Shared constants for test scenarios and expected results
- [ ] **Mock Abstraction**: Clean separation between mocked and live implementations

### Should Have

- [ ] **Test Helper Documentation**: Clear documentation on when to use shared vs specific helpers
- [ ] **Coverage Validation**: Verify 100% widget test coverage and 75-85% integration coverage
- [ ] **Performance Optimization**: Faster test execution through better code organization
- [ ] **Maintenance Reduction**: Easier to maintain tests with shared code

### Could Have

- [ ] **Test Code Generation**: Templates for creating new tests with shared code
- [ ] **Cross-Test Validation**: Ensure widget and integration tests cover same scenarios
- [ ] **Test Report Consolidation**: Combined coverage reports showing widget vs integration
  coverage

## Technical Implementation

### 1. Shared Test Utilities

#### Base Test Utilities

```dart
// test/shared/test_utilities.dart
class TestUtilities {
  // Common app initialization
  static Future<void> initializeApp(WidgetTester tester, {bool useMocks = false}) async {
    if (useMocks) {
      await _setupMocks();
    }
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
  }

  // Common login flow
  static Future<void> performLogin(
    WidgetTester tester, {
    required String username,
    required String password,
    bool useMocks = false,
  }) async {
    if (useMocks) {
      when(mockAuthService.login(username, password))
          .thenAnswer((_) async => AuthToken.valid());
    }
    
    await tester.enterText(find.byKey(const ValueKey('login_username_field')), username);
    await tester.enterText(find.byKey(const ValueKey('login_password_field')), password);
    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pumpAndSettle();
  }
}
```

#### Shared Test Data

```dart
// test/shared/test_data.dart
class TestData {
  static const validCredentials = {
    'username': 'test@example.com',
    'password': 'testpass123',
  };

  static const verseScenarios = {
    'correct': {
      'verse': 'He is before all things, and in him all things hold together.',
      'reference': 'Col 1:17',
      'expectedColor': Colors.green,
      'expectedMessage': 'Correct!',
    },
    'almostCorrect': {
      'verse': 'It is for freedom that Christ has set us free',
      'expectedReference': 'Gal 5:1',
      'userInput': 'Gal 5:2',
      'expectedColor': Colors.orange,
      'expectedMessage': 'Not quite right',
    },
  };

  static const validationErrors = {
    'empty': 'Reference cannot be empty',
    'invalidFormat': 'Invalid reference format',
  };
}
```

#### Widget Interaction Helpers

```dart
// test/shared/widget_helpers.dart
class WidgetHelpers {
  // Color validation shared between widget and integration tests
  static void validateInputFieldColor(WidgetTester tester, Color expectedColor) {
    final textField = find.byType(TextField).last;
    final widget = tester.widget<TextField>(textField);
    final decoration = widget.decoration as InputDecoration;
    
    final actualColor = decoration.focusedBorder?.borderSide.color ?? 
                       decoration.enabledBorder?.borderSide.color;
    
    expect(actualColor, expectedColor);
  }

  // Verse input interaction
  static Future<void> enterVerseReference(
    WidgetTester tester, 
    String reference, {
    bool shouldSubmit = true,
  }) async {
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.last, reference);
    
    if (shouldSubmit) {
      await tester.tap(find.byKey(const Key('submit-ref')));
      await tester.pumpAndSettle();
    }
  }
}
```

### 2. Widget Test Enhancement (100% Coverage)

#### Mocked Widget Tests

```dart
// test/widget_tests/authentication_widget_test.dart
class AuthenticationWidgetTest {
  late MockAuthService mockAuthService;
  late MockVerseRepository mockVerseRepository;

  void setUp() {
    mockAuthService = MockAuthService();
    mockVerseRepository = MockVerseRepository();
  }

  void testLoginSuccess() {
    testWidgets('login with valid credentials shows main screen', (tester) async {
      // Setup mocks for 100% coverage
      when(mockAuthService.login(any, any)).thenAnswer((_) async => AuthToken.valid());
      when(mockVerseRepository.getVerses()).thenAnswer((_) async => TestData.mockVerses);

      // Use shared utilities
      await TestUtilities.initializeApp(tester, useMocks: true);
      await TestUtilities.performLogin(
        tester,
        username: TestData.validCredentials['username']!,
        password: TestData.validCredentials['password']!,
        useMocks: true,
      );

      // Verify using shared validation
      expect(find.text('Memverse Reference Test'), findsOneWidget);
    });
  }

  void testLoginFailure() {
    testWidgets('login with invalid credentials shows error', (tester) async {
      // Mock failure scenario for 100% coverage
      when(mockAuthService.login(any, any)).thenThrow(AuthException('Invalid credentials'));

      await TestUtilities.initializeApp(tester, useMocks: true);
      await TestUtilities.performLogin(
        tester,
        username: 'invalid@email.com',
        password: 'wrongpass',
        useMocks: true,
      );

      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  }
}
```

### 3. Integration Test Simplification (Live Data)

#### Simplified Integration Tests

```dart
// integration_test/step/i_am_logged_in_as_test_user.dart
Future<void> iAmLoggedInAsTestUser(WidgetTester tester) async {
  // Simple integration test using shared utilities with live data
  await TestUtilities.performLogin(
    tester,
    username: String.fromEnvironment('MEMVERSE_USERNAME', defaultValue: TestData.validCredentials['username']!),
    password: String.fromEnvironment('MEMVERSE_PASSWORD', defaultValue: TestData.validCredentials['password']!),
    useMocks: false, // Live data
  );
}
```

## Implementation Tasks

### Phase 1: Code Analysis and Planning (1 point)

- [ ] Analyze existing widget and integration tests for duplication
- [ ] Identify common patterns and shared functionality
- [ ] Design shared code architecture and interfaces
- [ ] Plan migration strategy for existing tests

### Phase 2: Shared Utilities Creation (2 points)

- [ ] Create `test/shared/test_utilities.dart` with common functions
- [ ] Create `test/shared/test_data.dart` with shared constants
- [ ] Create `test/shared/widget_helpers.dart` with interaction helpers
- [ ] Create `test/shared/validation_helpers.dart` with assertion utilities

### Phase 3: Widget Test Enhancement (3 points)

- [ ] Refactor existing widget tests to use shared utilities
- [ ] Add comprehensive mocking for 100% coverage scenarios
- [ ] Create widget tests for error conditions and edge cases
- [ ] Validate 100% coverage achievement for widget tests

### Phase 4: Integration Test Refactoring (1 point)

- [ ] Simplify integration tests to use shared utilities with live data
- [ ] Remove duplicate code from integration test step definitions
- [ ] Ensure integration tests maintain 75-85% coverage focus
- [ ] Validate integration test reliability with live data

### Phase 5: Documentation and Validation (1 point)

- [ ] Document shared code architecture and usage patterns
- [ ] Create guidelines for when to use widget vs integration tests
- [ ] Validate overall test coverage and performance improvements
- [ ] Update CI/CD workflows to leverage new test structure

## Coverage Strategy

### Widget Tests (100% Coverage Goal)

- **How**: Comprehensive mocking of all dependencies
- **What**: Every code path, error condition, edge case
- **Focus**: Isolated component behavior with complete control
- **Benefits**: Fast execution, deterministic results, complete coverage

### Integration Tests (75-85% Coverage Goal)

- **How**: Live data and real API calls
- **What**: Happy paths, basic error handling, user flows
- **Focus**: End-to-end functionality with real dependencies
- **Benefits**: Real-world validation, user journey verification

### Complementary Coverage

- **Widget Tests**: Cover code paths that integration tests cannot reach
- **Integration Tests**: Cover real-world interactions that mocks cannot replicate
- **Shared Code**: Ensures consistent test scenarios across both approaches

## Success Criteria

### Definition of Done

- [ ] Shared test utilities created and documented
- [ ] Widget tests refactored to achieve 100% coverage with mocks
- [ ] Integration tests simplified to use shared code with live data
- [ ] Code duplication eliminated between test types
- [ ] Test execution performance improved
- [ ] Documentation updated with new test architecture
- [ ] CI/CD workflows updated to leverage shared code

### Validation Metrics

- **Widget Test Coverage**: 100% (verified with `flutter test --coverage`)
- **Integration Test Coverage**: 75-85% (verified with integration test coverage)
- **Code Duplication**: Reduced by 50%+ (measured by shared code usage)
- **Test Execution Time**: Improved by 20%+ (faster shared utilities)
- **Maintenance Overhead**: Reduced (single source of truth for test logic)

## Risk Assessment

### High Risk

- **Breaking Existing Tests**: Refactoring may break currently passing tests
- **Coverage Regression**: Changes might reduce overall coverage
- **Test Reliability**: Shared code might introduce new failure points

### Mitigation Strategies

- Implement changes incrementally with validation at each step
- Maintain comprehensive test coverage reports throughout refactoring
- Add integration tests for shared test utilities themselves
- Create rollback plan for each phase of implementation

## Benefits

### Development Efficiency

- **Reduced Duplication**: Single source of truth for test logic
- **Faster Test Creation**: Reusable utilities for new tests
- **Easier Maintenance**: Changes to test logic in one place

### Test Quality

- **Consistent Scenarios**: Same test cases across widget and integration tests
- **Better Coverage**: 100% widget coverage + 75-85% integration coverage
- **Improved Reliability**: Shared, well-tested utilities

### Team Productivity

- **Clear Patterns**: Established conventions for test creation
- **Documentation**: Clear guidance on when to use each test type
- **Reduced Cognitive Load**: Familiar utilities across all tests

## Notes

This refactoring recognizes that widget tests and integration tests serve different purposes and
should have different coverage goals. Widget tests should achieve 100% coverage through
comprehensive mocking, while integration tests should focus on realistic user scenarios with live
data.

The shared code architecture enables both approaches to coexist efficiently while eliminating
duplication and improving maintainability.