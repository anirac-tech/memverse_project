# Charlatan vs Fake JSON Analysis for Flutter Testing

## Executive Summary

This analysis compares **Charlatan** (pub.dev) with the **fake JSON pattern** used in Riverpod
examples (like fake_marvel.dart) for Flutter/Dart testing. The goal is to determine the best
approach for our 3-tiered testing strategy: live integration tests, mocked integration tests, and
mocked widget tests.

## 🎯 Current Context

We're implementing a comprehensive testing strategy with:

1. **Live Integration Tests**: Real API calls, manual cleanup required
2. **Mocked Integration Tests**: Mocked services, isolated environment
3. **Mocked Widget Tests**: Fast unit-level tests with mocked dependencies

**Target Coverage**: 90%+ across all test types

## 📊 Comparison Matrix

| Feature                  | Fake JSON Pattern      | Charlatan    | Winner       |
|--------------------------|------------------------|--------------|--------------|
| **Learning Curve**       | Easy (Riverpod native) | Easy         | 🤝 Tie       |
| **Code Generation**      | None                   | None         | 🤝 Tie       |
| **Performance**          | Excellent              | Excellent    | 🤝 Tie       |
| **Type Safety**          | Strong                 | Strong       | 🤝 Tie       |
| **Riverpod Integration** | Native                 | Manual       | 🏆 Fake JSON |
| **Pattern Consistency**  | Existing codebase      | New approach | 🏆 Fake JSON |
| **BDD Integration**      | Manual                 | Natural      | 🏆 Charlatan |
| **Data Realism**         | JSON Literals          | Dynamic      | 🏆 Fake JSON |

## 🔧 Technical Deep Dive

### Fake JSON Pattern (Like fake_marvel.dart)

```dart
// lib/src/features/auth/data/fake_auth_data.dart
class FakeAuthData {
  static const String dummyUserResponse = '''
  {
    "user": {
      "id": "dummy_123",
      "email": "dummynewuser@dummy.com",
      "username": "dummyuser",
      "created_at": "2025-06-30T19:46:00Z"
    },
    "access_token": "dummy_token_12345",
    "token_type": "Bearer",
    "expires_in": 3600
  }''';

  static const String errorResponse = '''
  {
    "error": "user_exists",
    "message": "User already exists"
  }''';
}

// Repository implementation
class FakeUserRepository implements UserRepository {
  @override
  Future<User> createUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (email == 'dummynewuser@dummy.com') {
      final json = jsonDecode(FakeAuthData.dummyUserResponse);
      return User.fromJson(json['user']);
    }

    throw Exception('User creation failed');
  }
}

// Provider overrides in tests
final container = ProviderContainer(
  overrides: [
    userRepositoryProvider.overrideWith((ref) => FakeUserRepository()),
  ],
);
```

### Charlatan Approach

```dart
// With Charlatan
void main() {
  late TestDouble<UserRepository> userRepository;

  setUp(() {
    userRepository = TestDouble<UserRepository>();
  });

  testWidgets('should create user successfully', (tester) async {
    // Arrange
    userRepository.when.createUser(any, any).thenReturn(
      User(id: '123', email: 'test@example.com'),
    );

    // Act & Assert
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userRepositoryProvider.overrideWithValue(userRepository),
        ],
        child: SignupPage(),
      ),
    );
  });
}
```

## 🎯 BDD Integration Analysis

### Fake JSON + BDD

```dart
// Current pattern in step definitions
Given
('the user repository has test data
'
, () async {
// Override repository with fake implementation using JSON data
await app.setUp(overrides: [
userRepositoryProvider.overrideWith((ref) => FakeUserRepository()),
]);
});

When('I sign up with dummy email', () async {
// Repository automatically returns fake JSON data
final user = await tester.binding.defaultBinaryMessenger.send(
'create_user',
utf8.encode('{"email": "dummynewuser@dummy.com"}')
);
expect(user, isNotNull);
});

Then('I should see the success screen', () {
// Verify UI shows fake data from JSON
expect(find.text('Welcome to Memverse!'), findsOneWidget);
});
```

### Charlatan + BDD

```dart
// More flexible BDD integration
Given
('the user repository returns user for {string}
'
, (String email) {
userRepository.when.createUser(email, any).thenReturn(
User(id: 'dynamic_123', email: email),
);
});

When('I sign up with email {string}', (String email) async {
// Can dynamically configure behavior per scenario
userRepository.when.createUser(email, any).thenReturn(
User(id: 'test_id', email: email),
);
});

Then('I should see success for {string}', (String email) {
expect(find.text('Welcome to Memverse!'), findsOneWidget);
expect(userRepository.calledMethods, contains('createUser'));
});
```

## 🚀 Performance Comparison

### Build Time Impact

| Pattern   | Code Generation | Build Time Impact | Hot Reload Impact |
|-----------|-----------------|-------------------|-------------------|
| Fake JSON | None            | Minimal (<2s)     | None              |
| Charlatan | None            | Minimal (<2s)     | None              |

### Test Execution Speed

- **Fake JSON**: ~150ms per test (includes fake network delay + JSON parsing)
- **Charlatan**: ~100ms per test (no simulated delays or JSON parsing)

## 🎨 Developer Experience

### Fake JSON Pattern Pros

- ✅ Already implemented in codebase (`FakeVerseRepository`)
- ✅ Native Riverpod integration with `overrideWith`
- ✅ Realistic data structure using JSON literals
- ✅ No internet connection required for tests
- ✅ Easy to maintain test data in JSON format
- ✅ Similar to Square's MockWebServer approach

### Fake JSON Pattern Cons

- ❌ Less flexible for dynamic test scenarios
- ❌ JSON strings can become large and unwieldy
- ❌ Manual BDD integration setup
- ❌ JSON parsing overhead in tests

### Charlatan Pros

- ✅ Dynamic behavior configuration
- ✅ Natural BDD integration
- ✅ Better for parameterized tests
- ✅ Call verification built-in
- ✅ More flexible assertions

### Charlatan Cons

- ❌ Additional dependency to maintain
- ❌ New pattern for team to learn
- ❌ Less realistic data structure
- ❌ Requires manual Riverpod provider overrides

## 🎯 Recommendation for Our Use Case

### For MEM-160 Signup Implementation

**Recommended**: **Fake JSON Pattern** for the following reasons:

1. **Existing Pattern**: Already implemented and working with `FakeVerseRepository`
2. **Riverpod Native**: Perfect integration with provider overrides
3. **No Internet Required**: Perfect for dummy signup testing
4. **Realistic Data**: JSON literals match real API responses

### Implementation Strategy

```dart
// 1. Live Integration Tests (existing)
// Keep current approach with real API calls

// 2. Mocked Integration Tests (extend existing pattern)
class FakeUserRepository implements UserRepository {
  @override
  Future<User> createUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (email == 'dummynewuser@dummy.com') {
      final json = jsonDecode(FakeAuthData.dummyUserResponse);
      return User.fromJson(json['user']);
    }

    if (email == 'existing@example.com') {
      throw Exception(jsonDecode(FakeAuthData.errorResponse)['message']);
    }

    throw Exception('User creation failed');
  }
}

// Provider override
final userRepositoryProvider = Provider<UserRepository>(
      (ref) => LiveUserRepository(ref),
);

// Test usage
testWidgets
('signup flow with fake user service
'
, (tester) async {
await tester.pumpWidget(
ProviderScope(
overrides: [
userRepositoryProvider.overrideWith((ref) => FakeUserRepository()),
],
child: SignupPage(),
),
);
});
```

## 📋 Migration Path

### Phase 1: Extend Existing Pattern (This PR)

- Create `FakeAuthData` class with JSON literals
- Create `FakeUserRepository` for signup testing
- Create all 4 test types: Maestro, BDD widget, integration, widget
- Document fake JSON patterns and conventions

### Phase 2: Enhance Coverage (Next PR)

- Add more fake service implementations
- Create test data factories for consistency
- Achieve 90%+ coverage target with existing pattern

### Phase 3: Evaluate Charlatan (Future PR)

- Pilot Charlatan for complex scenarios requiring dynamic behavior
- Compare developer experience and productivity
- Consider hybrid approach if benefits justify complexity

## 🔮 Future Considerations

### Hybrid Approach Option

- Use **Fake JSON pattern** for standard CRUD operations and realistic data
- Use **Charlatan** for complex scenarios requiring dynamic mocking
- Maintain consistency with Riverpod provider override patterns

### Decision Points to Monitor

1. **Data Complexity**: Do JSON literals become too large to maintain?
2. **BDD Complexity**: How complex do our BDD scenarios become?
3. **Team Productivity**: Is the existing pattern limiting development speed?
4. **Maintenance Overhead**: How much effort does each approach require?

## 🎯 Conclusion

**For MEM-160 and our 3-tiered testing strategy, the Fake JSON pattern is the recommended choice**
due to:

- Perfect alignment with existing codebase (`FakeVerseRepository`)
- Native Riverpod integration
- Realistic data structure using JSON literals
- No internet connection required
- Similar to industry standard MockWebServer approach

We can always introduce Charlatan later for specific scenarios requiring dynamic behavior, but the
fake JSON pattern provides the best foundation for our immediate dummy signup implementation needs.

---

**Next Steps**:

1. Create `FakeAuthData` class with JSON literals
2. Create all 4 test types for dummy signup
3. Ensure no internet connection required
4. Document fake JSON patterns in `test/README.md`
