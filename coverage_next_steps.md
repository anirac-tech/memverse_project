# Coverage Analysis & Next Steps

## Current Coverage Status: 74.3% (428/576 lines)

This document analyzes the uncovered code paths in the Memverse app test suite and provides
strategies to increase coverage, particularly focusing on integration tests that can realistically
achieve high coverage for live API scenarios.

## Coverage Breakdown by Module

### ✅ **High Coverage Areas (90%+)**

- `src/features/verse/presentation/widgets/`: **100%** (37/37 lines)
- `src/features/verse/presentation/memverse_page.dart`: **97.9%** (92/94 lines)
- `src/features/auth/presentation/login_page.dart`: **100%** (56/56 lines)
- `src/features/verse/domain/`: **100%** (17/17 lines)
- `src/features/auth/domain/`: **100%** (15/15 lines)

### ⚠️ **Medium Coverage Areas (50-89%)**

- `src/features/auth/presentation/providers/auth_providers.dart`: **66.0%** (31/47 lines)
- `src/features/verse/presentation/feedback_service.dart`: **84.8%** (56/66 lines)
- `l10n/arb/app_localizations_en.dart`: **57.1%** (20/35 lines)

### ❌ **Low Coverage Areas (<50%)**

- `src/features/auth/data/auth_service.dart`: **4.7%** (2/43 lines)
- `src/bootstrap.dart`: **20.8%** (5/24 lines)
- `l10n/arb/app_localizations_es.dart`: **0%** (0/35 lines)
- `src/features/auth/presentation/auth_wrapper.dart`: **40%** (4/10 lines)

## Uncovered Lines Analysis

### 1. Authentication Service (`auth_service.dart`) - **41 uncovered lines**

**Uncovered Code Paths:**

```dart
// Lines 25-92: Live API authentication calls
DA:25,0  // login method entry
DA:27,0  // API request setup
DA:28,0  // HTTP POST to auth endpoint
DA:29,0  // Response handling
DA:34,0  // Token extraction
DA:38,0  // Error handling branches
DA:46,0  // Logout functionality
DA:48,0  // Token invalidation
// ... additional API interaction code
```

**Strategy for Coverage:**

- ✅ **Achievable with Integration Tests**: Use live credentials for actual API calls
- ✅ **BDD Widget Tests**: Test full auth flow with real backend
- ❌ **Exception Handling**: API errors won't be reliably reproducible

### 2. Bootstrap (`bootstrap.dart`) - **19 uncovered lines**

**Uncovered Code Paths:**

```dart
// Lines 25-53: Error handling and logging setup
DA:25,0  // Error reporter initialization
DA:27,0  // Crash reporting setup  
DA:28,0  // Logger configuration
DA:42,0  // Exception handler registration
DA:49,0  // Error callback setup
// ... error handling infrastructure
```

**Strategy for Coverage:**

- ❌ **Not Suitable for Integration Tests**: Infrastructure/setup code
- ❌ **Exception Handling**: Crash scenarios not reproducible
- ✅ **Unit Tests Only**: Mock error conditions

### 3. Auth Providers (`auth_providers.dart`) - **16 uncovered lines**

**Uncovered Code Paths:**

```dart
// Lines 43, 59, 79-80, 104-115: Error states and edge cases
DA:43,0   // Authentication failure branch
DA:59,0   // Token validation failure
DA:79,0   // Logout error handling
DA:104,0  // State persistence errors
DA:109,0  // Client ID validation failure
```

**Strategy for Coverage:**

- ✅ **Integration Tests**: Test with invalid credentials
- ✅ **BDD Scenarios**: Add negative test cases
- ⚠️ **Some Exception Handling**: Network timeouts may not be reproducible

### 4. Feedback Service (`feedback_service.dart`) - **10 uncovered lines**

**Uncovered Code Paths:**

```dart
// Lines 28, 31, 87-88, 101-102, 122, 161: Error handling
DA:28,0   // File system errors
DA:31,0   // Permission errors
DA:87,0   // Email composition failures
DA:101,0  // Platform-specific errors
```

**Strategy for Coverage:**

- ❌ **Not Integration Test Friendly**: Platform-specific edge cases
- ✅ **Unit Tests**: Mock platform services

### 5. Localization Files - **51 uncovered lines**

**Uncovered Code Paths:**

- Spanish translations: **35 lines** (entirely unused in tests)
- English translations: **15 lines** (error messages, edge case text)

**Strategy for Coverage:**

- ✅ **Easy Integration Test Wins**: Use more UI text assertions
- ✅ **BDD Scenarios**: Test error message display
- ✅ **Localization Tests**: Switch language settings

### 6. Auth Wrapper (`auth_wrapper.dart`) - **6 uncovered lines**

**Uncovered Code Paths:**

```dart
// Lines 15-16, 18, 23, 25, 27: Unauthenticated user flow
DA:15,0  // Redirect to login when not authenticated
DA:16,0  // Show login screen
DA:18,0  // Handle auth state changes
```

**Strategy for Coverage:**

- ✅ **High Integration Test Potential**: Test logout flows
- ✅ **BDD Scenarios**: Add unauthenticated user journeys

## Coverage Improvement Strategies

### 🎯 **High-Impact, Low-Effort Wins (Expected +15-20%)**

#### 1. **Expand BDD Widget Test Scenarios**

```gherkin
# Add to test/features/happy_path.feature

Scenario: Authentication failure handling
  Given I am on the login screen
  When I enter invalid credentials
  Then I should see "Invalid username or password"
  And I should remain on the login screen

Scenario: Logout flow
  Given I am logged in
  When I tap the logout button
  Then I should see the login screen
  And I should not be able to access authenticated screens

Scenario: Unauthenticated access attempt
  Given I am not logged in
  When I try to access the main screen
  Then I should be redirected to login screen
```

#### 2. **Add Localization Test Coverage**

```dart
// New test: test/localization_widget_test.dart
testWidgets('All UI text elements are covered', (tester) async {
  // Test all visible text elements
  expect(find.textContaining('Reference'), findsOneWidget);
  expect(find.textContaining('Correct'), findsOneWidget);
  expect(find.textContaining('Not quite right'), findsOneWidget);
  // ... assert all text from l10n files
});
```

#### 3. **Negative Test Cases**

```dart
// Add to existing BDD tests
testWidgets('Invalid reference format handling', (tester) async {
  await iEnterTheReference(tester, 'invalid reference');
  await iTapTheSubmitButton(tester);
  expect(find.textContaining('Invalid reference format'), findsOneWidget);
});
```

### 🎯 **Medium-Impact Integration Test Additions (Expected +10-15%)**

#### 1. **Live Authentication Testing**

```dart
// test/live_auth_widget_test.dart
testWidgets('Live authentication flow', (tester) async {
  // Use actual API credentials
  await iEnterUsername(tester, Platform.environment['MEMVERSE_USERNAME']!);
  await iEnterPassword(tester, Platform.environment['MEMVERSE_PASSWORD']!);
  await iTapTheLoginButton(tester);
  
  // This will cover auth_service.dart live API calls
  expect(find.textContaining('Reference Test'), findsOneWidget);
});

testWidgets('Invalid credentials with live API', (tester) async {
  await iEnterUsername(tester, 'invalid@example.com');
  await iEnterPassword(tester, 'wrongpassword');
  await iTapTheLoginButton(tester);
  
  // This will cover error handling branches
  expect(find.textContaining('Invalid'), findsOneWidget);
});
```

#### 2. **Complete User Journey Tests**

```dart
testWidgets('Complete user session lifecycle', (tester) async {
  // Login -> Use app -> Logout -> Try to access -> Redirected
  await performCompleteLoginFlow(tester);
  await performVerseInteractions(tester);
  await performLogoutFlow(tester);
  await attemptUnauthenticatedAccess(tester);
});
```

### ❌ **Areas NOT Suitable for Integration Tests**

#### 1. **Exception Handling in Infrastructure Code**

- Bootstrap error handlers
- Platform-specific failures
- Network timeout edge cases
- File system permission errors

**Reason**: These scenarios cannot be reliably reproduced in integration tests with live APIs.

#### 2. **Crash Recovery Code**

- Error reporting initialization
- Crash handler registration
- Memory management edge cases

**Recommendation**: Cover with unit tests using mocks.

## Implementation Plan

### Phase 1: Quick Wins (Target: +20% coverage)

1. ✅ **Add negative test scenarios** to existing BDD tests
2. ✅ **Expand localization coverage** with text assertions
3. ✅ **Add logout flow testing** to happy path scenarios
4. ✅ **Test invalid input handling** for forms

### Phase 2: Live API Integration (Target: +15% coverage)

1. ✅ **Implement live authentication tests** with real credentials
2. ✅ **Add network error simulation** where possible
3. ✅ **Test complete user session lifecycle**
4. ✅ **Cover auth state management** with real state changes

### Phase 3: Edge Case Coverage (Target: +5% coverage)

1. ⚠️ **Platform-specific features** (limited integration test value)
2. ⚠️ **Error boundary testing** (requires mocking)
3. ⚠️ **Performance edge cases** (not integration test suitable)

## Expected Final Coverage

With focused integration test improvements:

| Component            | Current | Target     | Achievable?                |
|----------------------|---------|------------|----------------------------|
| **Overall**          | 74.3%   | **90-95%** | ✅ Yes                      |
| **Auth Service**     | 4.7%    | **70-80%** | ✅ Yes (live API)           |
| **Auth Providers**   | 66.0%   | **85-90%** | ✅ Yes (full flows)         |
| **Feedback Service** | 84.8%   | **90-95%** | ⚠️ Limited (platform code) |
| **Localization**     | 37.2%   | **80-90%** | ✅ Yes (text assertions)    |
| **Bootstrap**        | 20.8%   | **30-40%** | ❌ No (infrastructure)      |

## Implementation Files to Create/Update

### New Test Files

1. `test/live_auth_widget_test.dart` - Live API authentication testing
2. `test/localization_widget_test.dart` - Comprehensive text coverage
3. `test/negative_scenarios_widget_test.dart` - Error case testing
4. `test/session_lifecycle_widget_test.dart` - Complete user journeys

### Update Existing Files

1. `test/features/happy_path.feature` - Add negative scenarios
2. `test/happy_path_widget_test.dart` - Expand test coverage
3. `test/step/user_interactions.dart` - Add logout/error steps
4. `test/step/feedback_validation.dart` - Add error message validation

## Realistic Coverage Target: **90-92%**

With integration tests focused on user-facing scenarios and live API interactions, we can
realistically achieve 90-92% coverage. The remaining 8-10% will consist of:

- Infrastructure error handling (5-7%)
- Platform-specific exception cases (2-3%)
- Unreproducible network timeout scenarios (1-2%)

This represents excellent coverage for a production application with live API dependencies.