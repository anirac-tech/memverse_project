# Golden Tests in Memverse

This directory contains documentation about golden tests in the Memverse app.

## What are Golden Tests?

Golden tests are UI snapshot tests that capture the appearance of your application's widgets and
compare them against baseline images (the "golden" files). They help detect unintentional visual
changes.

## Directory Structure

Golden image files are stored in `goldens` directories next to the test files:

```
test/src/features/auth/presentation/
  ├── login_page_golden_test.dart
  └── goldens/
      └── login_page.png
```

Failed golden tests generate difference images in `failures` directories:

```
test/src/features/auth/presentation/
  ├── failures/
  │   └── login_page.png
  └── goldens/
      └── login_page.png
```

## Working with Golden Tests

### Creating a Golden Test

1. Create a test file with the naming convention `*_golden_test.dart`
2. Tag the test with `golden`: `testWidgets('My test', (tester) async {...}, tags: ['golden']);`
3. Use `expectLater` with `matchesGoldenFile`:

```dart
await expectLater
(
find.byType(MyWidget),
matchesGoldenFile('goldens/my_widget.png'
)
,
);
```

4. Run `./scripts/update_golden_files.sh` to generate the initial golden images

### Maintaining Golden Tests

When making UI changes:

1. Make your UI changes
2. Run golden tests: `flutter test --tags golden`
3. If tests fail, review the differences
4. If the changes are intentional, update the golden files:
   `flutter test --update-goldens --tags golden`
5. Commit both your code changes and the updated golden files

### Handling Device Differences

Different devices may render widgets differently. To handle this:

1. Use `testWidgets` with a predefined screen size:

```dart
testWidgets
('My test
'
, (tester) async {
tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
tester.binding.window.devicePixelRatioTestValue = 1.0;
addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

// Test code...
}, tags: ['golden']);
```

2. Consider separate golden tests for different device sizes or orientations

## CI/CD Integration

- Golden tests run in a separate GitHub workflow: `.github/workflows/golden_tests.yml`
- They don't fail the build even if differences are detected
- Differences are reported as PR comments with links to artifacts
- Golden images and difference images are uploaded as artifacts

## Utilities

- `./scripts/update_golden_files.sh`: Updates all golden files
- `./scripts/generate_golden_report.sh`: Generates HTML report comparing golden files and
  differences
- Pre-commit hook handles golden tests without failing the commit

## Best Practices

1. Keep golden tests focused on specific widgets/screens
2. Test different states (loading, error, success)
3. Test different device sizes
4. Update golden files when UI changes are intentional
5. Review golden test differences carefully in PRs