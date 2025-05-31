# JIRA Story: Red-Green-Refactor for 100% Coverage & Safe Refactoring

**Story ID**: MEM-RED-GREEN-REFACTOR  
**Priority**: High  
**Epic**: Testing Infrastructure & Code Quality  
**Estimation**: 8 Story Points

## Summary

Establish a red-green-refactor testing approach to achieve 100% test coverage (counting exclusions)
that enables safe refactoring of critical components like HTTP clients (Dio → http/retrofit), data
models (adding Freezed), and persistence layers (adding database).

## Problem Statement

Current codebase lacks comprehensive test coverage making major refactoring risky. Need bulletproof
test suite to safely:

1. Replace Dio with http or retrofit
2. Add Freezed for immutable data classes
3. Introduce database persistence
4. General architectural improvements

## Acceptance Criteria

### Phase 1: Red-Green Foundation (2-3 days)

- [ ] **100% line coverage** achieved (excluding reasonable exclusions)
- [ ] All existing tests pass consistently
- [ ] Coverage report shows detailed metrics per file
- [ ] Test exclusions documented and justified

### Phase 2: Black Box Test Setup (1-2 days)

- [ ] Integration tests cover all user journeys end-to-end
- [ ] API contracts validated with mock/real responses
- [ ] UI component behavior tested without implementation details
- [ ] Error scenarios and edge cases covered

### Phase 3: Refactor Safety Net (1 day)

- [ ] Pre-commit hooks run full test suite
- [ ] CI/CD pipeline blocks on test failures
- [ ] Test execution time under 30 seconds for unit tests
- [ ] Coverage threshold enforcement (95%+ excluding exclusions)

## Technical Approach

### Step 1: Immediate Coverage Boost

```bash
# Run coverage analysis
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

**Target Files for 100% Coverage:**

- `lib/src/features/verse/data/verse_repository.dart` ✓ (already good)
- `lib/src/features/auth/` (needs coverage)
- `lib/src/features/verse/presentation/` (needs coverage)
- `lib/src/utils/` (needs coverage)

### Step 2: Strategic Test Exclusions

Add to files requiring exclusions:

```dart
// coverage:ignore-file  // For generated files
// coverage:ignore-start // For debugging/dev code blocks  
// coverage:ignore-end
// coverage:ignore-line  // For specific lines
```

### Step 3: Black Box Integration Tests

```dart
// Example pattern for API testing
testWidgets
('verse loading flow works end-to-end
'
, (tester) async {
// Given: App is launched and user is authenticated
await tester.pumpWidget(TestApp());
await tester.pumpAndSettle();

// When: User navigates to verses
await tester.tap(find.byKey(Key('verses_tab')));
await tester.pumpAndSettle();

// Then: Verses are displayed
expect(find.byType(VerseCard), findsAtLeastNWidgets(1));
});
```

### Step 4: Refactor-Safe Architecture

1. **Interface Segregation**: Extract interfaces for all external dependencies
2. **Dependency Injection**: Use Riverpod providers for all dependencies
3. **Test Doubles**: Mock all external systems (API, storage, etc.)
4. **Contract Testing**: Validate API responses match expected schemas

## Refactoring Scenarios Enabled

### Scenario 1: Dio → http/retrofit

```dart
// Before refactor: Tests validate behavior, not implementation
test
('fetches verses successfully
'
, () async {
// Arrange
when(mockRepository.getVerses()).thenAnswer((_) async => mockVerses);

// Act & Assert - focuses on behavior, not HTTP client
final verses = await repository.getVerses();
expect(verses, equals(mockVerses));
});
```

### Scenario 2: Adding Freezed

```dart
// Tests validate data integrity, not specific class structure  
test
('verse data is immutable and comparable
'
, () {
final verse1 = Verse(text: 'test', reference: 'John 1:1');
final verse2 = Verse(text: 'test', reference: 'John 1:1');

expect(verse1, equals(verse2)); // Works with/without Freezed
});
```

### Scenario 3: Adding Database

```dart
// Repository tests work with any persistence mechanism
test
('verses persist between app sessions
'
, () async {
// Arrange
await repository.saveVerses(testVerses);

// Act  
final retrievedVerses = await repository.getVerses();

// Assert
expect(retrievedVerses, equals(testVerses));
});
```

## Implementation Checklist

### Immediate Actions (Day 1)

- [ ] Run `flutter test --coverage` and analyze gaps
- [ ] Add test exclusions for generated/debug code
- [ ] Write missing unit tests for uncovered lines
- [ ] Achieve 95%+ coverage (excluding reasonable exclusions)

### Foundation Setup (Day 2-3)

- [ ] Create comprehensive integration test suite
- [ ] Add API contract tests with mock responses
- [ ] Implement test data builders/factories
- [ ] Set up golden file tests for UI components

### Safety Infrastructure (Day 4-5)

- [ ] Configure pre-commit hooks for test execution
- [ ] Set CI/CD coverage thresholds
- [ ] Document testing patterns and conventions
- [ ] Create refactoring safety checklist

## Success Metrics

- **Code Coverage**: 100% lines covered (excluding documented exclusions)
- **Test Execution**: Full suite runs in <60 seconds
- **Refactor Confidence**: Can swap major dependencies without breaking tests
- **Regression Prevention**: All existing functionality validated by tests

## Risk Mitigation

- **Performance**: Parallel test execution and smart test selection
- **Maintenance**: Clear test organization and documentation
- **False Positives**: Focus on behavior over implementation details
- **Coverage Gaming**: Manual review of exclusions and meaningful assertions

## Definition of Done

- [ ] 100% line coverage achieved with justified exclusions
- [ ] All refactoring scenarios can be executed safely
- [ ] Test suite runs fast and reliably
- [ ] Documentation updated with testing standards
- [ ] Team aligned on red-green-refactor workflow

---

**Next Actions**: Execute Phase 1 immediately to establish coverage baseline, then proceed with
black-box integration tests for bulletproof refactoring safety.