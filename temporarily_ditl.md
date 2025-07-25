# Memverse DITL - Maestro Dummy Sign-In UI Validation (GREEN STATUS TRACKER)

## STATUS: WIP - Working through Maestro automated UI/screenshot validation for dummy sign-in user with mock data and pretty theming.

### Dummy user: `dummysigninuser@dummy.com` (any password)

### Flow: Automated UI screenshots for Home, Ref Quiz, Verse Quiz tabs

## TASK PLAN - GoRouter + Provider Mock/Testing for Tabs (Manual+Emulator Validation)

### WHAT I'M DOING

- Refactor main.dart to use GoRouter (with tabs, ShellRoute, and deep navigation).
- Ensure mocking is active for integration/dev/test (NoOpAnalyticsService, FakeVerseRepository,
  dummy user).
- Provide robust ProviderScope overrides for tests and manual runs (by
  --dart-define=INTEGRATION_TEST=true).
- Guide both emulator (me) and physical device (you) for UI validation with hot reload.

### CHECKLIST FOR MANUAL+EMULATOR TEST

- [ ] App launches with new GoRouter/navigation structure and tab ShellRoute.
- [ ] "Verse" tab is default (first screen).
- [ ] Navigation between Home, Verse, Ref, Settings tabs works and preserves state.
- [ ] Analytics/logging is disabled in dummy/integration mode.
- [ ] Verse fetching is mocked in dummy/integration mode.
- [ ] Hot reload works without navigation or provider crashes.
- [ ] adb screenshot yields correct UI snapshot (for emulator testing).
- [ ] Physical device: Use standard device screenshots to compare with expected tabs/UI states.

### HOW TO MONITOR/MANUALLY TEST

1. Launch app with:
   ```sh
   flutter run --dart-define=INTEGRATION_TEST=true
   ```
   or using your flavor as appropriate (see setup.md).
2. Switch between tabs and verify correct UI and mock content for "Verse" tab.
3. Trigger hot reload (`r` in terminal or IDE action) and verify tab state and content persist.
4. On emulator, take screenshot via:
   ```sh
   adb exec-out screencap -p > emulator_screen.png
   ```
5. Compare appearance/state with expected design and mark checkboxes above.
6. If anything is wrong (tab order, navigation, mock data, etc.), fix and re-run/hot reload.

#### Checklist (Updated at each run)

- [x] Build debug APK, install on device/emulator -- success
- [x] Maestro YAML flows fixed, appId matches installed APK -- success
- [x] Dummy login returns instant success and mock data -- success
- [x] Maestro test launches app, scripts fields/buttons/tabs, expects Home/Ref/Verse visible --
  running
- [ ] Screenshots generated for:
    - [ ] after_login.png (Home)
    - [ ] ref_quiz.png (Ref/Review tab, with reference quiz UI, not blue, should match green/yellow
      theme)
    - [ ] verse_quiz.png (Verse quiz tab, Gal 5:22 display, green/yellow theme, with AppBar and
      pretty
      container)
- [ ] UI prettiness: Compare Maestro run screenshots against attached PNG (all must show matching
  green, AppBar, cards, tabs)
- [ ] If any screenshot/step fails, update selectors, themes, or widgets and rerun Maestro
- [ ] Once all boxes above are checked, finalize artifact review for user

## Troubleshooting

- If Maestro cannot find a field, adjust the placeholder/text value to match the actual UI widget
  label/hint.
- If app UI has unexpected blue or wrong theme, patch that widget+rerun test
- Use `maestro studio` for visual selector inspection if stuck
- Always ensure device/emulator has com.spiritflightapps.memverse.dev installed, not old package
  name

**Progress will be updated after each Maestro run or theming/selector tweak until UI matches
screenshot.**
