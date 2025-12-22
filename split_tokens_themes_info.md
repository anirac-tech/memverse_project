# Splitting Tokens and Themes: Advanced Design System

For future growth or multiple brand support, consider splitting your design tokens and app ThemeData
into two files:

---

**1. `memverse_tokens.dart`**  — Only constants!

- All raw colors, spacings, radii, durations, and font sizes live here as constants.
- There is no ThemeData or widget code in this file.
- Example:
  ```dart
  // Colors
  const kPrimary = Color(0xFF224600);
  const kError = Color(0xFFE33244);
  // Spacing
  const kSpacingS = 8.0;
  const kSpacingM = 16.0;
  // Radii
  const kRadiusM = 12.0;
  // Motion
  const kAnimFast = Duration(milliseconds: 150);
  ```

---

**2. `themes.dart`**  — Actual ThemeData, mapping tokens

- Import your tokens/constants file.
- Build light/dark/app/feedback themes for MaterialApp, all from tokens.
- Example:
  ```dart
  import 'memverse_tokens.dart';
  ...
  final ThemeData lightTheme = ThemeData(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: kBackground,
    textTheme: TextTheme(
      headlineMedium: TextStyle(fontSize: kFontSizeXL, color: kPrimary),
      ...
    ),
    cardTheme: CardTheme(... radius: kRadiusM ...),
    ...
  );
  ```

---

## Benefits

- **Design system clarity:** Designers and devs can modify tokens for fast updates.
- **Rebrand-readiness:** Swap out token values and the whole app updates—no widget changes needed.
- **Multi-brand support:** Add a new tokens file, map it into additional ThemeData.
- **Testing and linting:** Tests can verify tokens aren’t used directly in widgets—only in cache or
  theme files.

## When to use this pattern?

- When your app is scaling or will need light/dark/multiple brands.
- When designers want independent control over values (from code).
- When you want extreme workshop/future-proofing for your visual system.

## Next Steps

- If you decide to split, start by migrating all constants from themes.dart to memverse_tokens.dart,
  import and use them in ThemeData construction, and use ONLY ThemeData/app theme/feedback theme for
  widgets.
