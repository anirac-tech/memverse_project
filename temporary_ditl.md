# NavBar Theming/Entrypoint Debug DITL

## Steps/Progress

- [x] Searched for all MaterialApp/Theme usage to detect accidental shadowing of primary theme.
- [x] Checked for direct `Container`, `BoxDecoration`, or `backgroundColor` on the nav or its
  container (none found shadowing the navigation bar).
- [x] Audited `main.dart`, `main_development.dart`, `main_staging.dart`, and `bootstrap.dart`
  entrypoints:
    - [x] main.dart: Fixed to always launch the `App` widget from `app.dart` for theme consistency.
    - [x] main_development.dart: Already uses `bootstrap(() => App())` (GOOD).
    - [x] main_staging.dart: Already uses `bootstrap(() => App())` (GOOD).
    - [x] bootstrap.dart: Handles config error only, does not shadow the app theme.
- [ ] TODO: Confirm after this change, nav theming propagates in ALL envs (dev, staging, prod,
  test).
- [ ] TODO: If manual widget coloring is ever reintroduced, remove from `TabScaffold` or similar
  widgets in the router tree.
- [ ] TODO: Document and verify that ALL MaterialApp instantiations in the repo defer to centralized
  `App` theme, or are never used.
- [ ] TODO: Run the app with changes and visually verify theme enforcement.

**Outcome:** After above, global nav theming should work regardless of entrypoint.

