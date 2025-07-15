# Memverse DITL - Maestro Dummy Sign-In UI Validation (GREEN STATUS TRACKER)

## STATUS: WIP - Working through Maestro automated UI/screenshot validation for dummy sign-in user with mock data and pretty theming.

### Dummy user: `dummysigninuser@dummy.com` (any password)

### Flow: Automated UI screenshots for Home, Ref Quiz, Verse Quiz tabs

#### Checklist (Updated at each run)

- [x] Build debug APK, install on device/emulator -- success ✅
- [x] Maestro YAML flows fixed, appId matches installed APK -- success ✅
- [x] Dummy login returns instant success and mock data -- success ✅
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
