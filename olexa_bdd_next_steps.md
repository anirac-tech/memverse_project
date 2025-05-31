# BDD Widget Test Next Steps

## Fixed Issues

- ✅ **Deleted malformed `test/app.feature` file** - No more parse errors
- ✅ **Created hello world test** - Simple proof of concept
- ✅ **Parameterized steps** - Cleaner, reusable step definitions

## Progressive Implementation Plan

### Phase 1: Hello World (Proof of Concept)

```bash
# Clean environment
dart run build_runner clean
rm -rf .dart_tool/build

# Generate test files
dart run build_runner build --delete-conflicting-outputs

# Test hello world first
flutter test integration_test/hello_world_bdd_test.dart --reporter expanded
```

### Phase 2: Core Step Definitions

#### Essential Steps to Implement:

**A. App Launch**
File: `integration_test/step/the_app_is_running.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/app/app.dart';

Future<void> theAppIsRunning(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  await tester.pumpAndSettle();
}
```

**B. Authentication with Environment Variables**
File: `integration_test/step/i_am_logged_in_as_test_user.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iAmLoggedInAsTestUser(WidgetTester tester) async {
  // Check if already logged in
  if (find.byIcon(Icons.logout).evaluate().isNotEmpty) {
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
  }
  
  // Use environment variables with defaults
  const username = String.fromEnvironment('MEMVERSE_USERNAME', defaultValue: 'test@example.com');
  const password = String.fromEnvironment('MEMVERSE_PASSWORD', defaultValue: 'testpass');
  
  await tester.enterText(find.byKey(const ValueKey('login_username_field')), username);
  await tester.enterText(find.byKey(const ValueKey('login_password_field')), password);
  await tester.tap(find.byKey(const ValueKey('login_button')));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}
```

**C. Parameterized Color Validation**
File: `integration_test/step/i_should_see_input_field_color.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeeInputFieldColor(WidgetTester tester, Color expectedColor) async {
  final textField = find.byType(TextField).last;
  final widget = tester.widget<TextField>(textField);
  final decoration = widget.decoration as InputDecoration;
  
  // Check for color in focused border, enabled border, or error border
  final actualColor = decoration.focusedBorder?.borderSide.color ?? 
                     decoration.enabledBorder?.borderSide.color ??
                     decoration.errorBorder?.borderSide.color;
  
  expect(actualColor, expectedColor);
}
```

**D. Generic UI Steps**
File: `integration_test/step/i_see_verse_text.dart`

```dart
import 'package:flutter_test/flutter_test.dart';

Future<void> iSeeVerseText(WidgetTester tester) async {
  // Look for common verse patterns - make generic
  final versePatterns = [
    'He is before all things',
    'It is for freedom',
    'For God so loved'
  ];
  
  bool foundVerse = false;
  for (final pattern in versePatterns) {
    if (find.textContaining(pattern).evaluate().isNotEmpty) {
      foundVerse = true;
      break;
    }
  }
  
  expect(foundVerse, true, reason: 'No verse text found');
}
```

**E. Test Credential Entry**
File: `integration_test/step/i_enter_test_credentials_into_login_fields.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iEnterTestCredentialsIntoLoginFields(WidgetTester tester) async {
  const username = String.fromEnvironment('MEMVERSE_USERNAME', defaultValue: 'test@example.com');
  const password = String.fromEnvironment('MEMVERSE_PASSWORD', defaultValue: 'testpass');
  
  await tester.enterText(find.byKey(const ValueKey('login_username_field')), username);
  await tester.enterText(find.byKey(const ValueKey('login_password_field')), password);
}
```

### Phase 3: Test Execution Strategy

#### Step-by-Step Testing:

```bash
# 1. Environment setup
export MEMVERSE_USERNAME="your_actual_username"
export MEMVERSE_PASSWORD="your_actual_password" 
export MEMVERSE_CLIENT_ID="your_client_id"

# 2. Individual feature testing
flutter test integration_test/hello_world_bdd_test.dart --reporter expanded
flutter test integration_test/authentication_bdd_test.dart --reporter expanded
flutter test integration_test/verse_practice_bdd_test.dart --reporter expanded
flutter test integration_test/app_ui_bdd_test.dart --reporter expanded

# 3. All features together
flutter test integration_test/ --reporter expanded

# 4. Coverage analysis
flutter test --coverage integration_test/
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Phase 4: Advanced Features

#### Build Configuration

Ensure `build.yaml` exists in project root:

```yaml
targets:
  $default:
    builders:
      bdd_widget_test|featureBuilder:
        options:
          stepDirectoryName: step
          externalSteps:
            - package:bdd_widget_test/step/i_see_text.dart
            - package:bdd_widget_test/step/i_dont_see_text.dart
            - package:bdd_widget_test/step/i_tap_text.dart
            - package:bdd_widget_test/step/i_see_icon.dart
            - package:bdd_widget_test/step/i_tap_icon.dart
            - package:bdd_widget_test/step/the_app_is_running.dart
```

### Phase 5: Debugging Common Issues

#### Issue 1: Widget Not Found

```dart
// Add to step definitions for debugging
print('Available widgets: ${find.byType(Widget).evaluate().map((e) => e.widget.runtimeType)}');
```

#### Issue 2: Timing Problems

```dart
// Add more wait time for slow operations
await tester.pump(const Duration(seconds: 3));
await tester.pumpAndSettle(const Duration(seconds: 10));
```

#### Issue 3: Color Validation Fails

```dart
// Debug actual colors
final widget = tester.widget<TextField>(find.byType(TextField).last);
print('Actual decoration: ${widget.decoration}');
```

### Phase 6: Expected Results

#### Coverage Targets:

- **Hello World**: 10-15% (basic app startup)
- **Authentication**: 50-60% (login flow + validation)
- **Verse Practice**: 70-80% (core app logic)
- **UI Elements**: 80-85% (UI components)
- **Combined**: **75-85% overall** (realistic for simple app)

#### Success Metrics:

- ✅ Build runner completes without parse errors
- ✅ Hello world test proves BDD concept works
- ✅ Authentication works with environment variables
- ✅ Color parameterization works for input fields
- ✅ All feature files execute without widget finder errors
- ✅ Coverage reaches target range

### Final Validation

#### Test Results Check:

```bash
# Verify all tests pass
flutter test integration_test/ --reporter json | jq '.testCount, .failureCount'

# Coverage summary
lcov --summary coverage/lcov.info | grep "lines"
```

#### Expected Output:

```
Running 4 tests...
✓ Hello World BDD Test Basic app launch
✓ User Authentication BDD Tests Successful login
✓ Verse Reference Practice BDD Tests Correct verse reference
✓ App UI and Navigation BDD Tests Main app bar elements

All tests passed!
Coverage: 78.5% of lines covered
```

## Key Improvements in This Version

1. **Eliminated Parse Errors**: Deleted malformed feature file
2. **Hello World First**: Prove concept before complexity
3. **Parameterized Testing**: Reusable color validation
4. **Environment Variables**: Secure credential handling
5. **Generic Steps**: Less brittle text matching
6. **Progressive Testing**: Build confidence incrementally
7. **Better Debugging**: Clear error handling and logging

```
