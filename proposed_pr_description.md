# PR: Centralize Theming, Tokens, and Service Mocks for Robust Design & Dev Experience

## Summary

This PR/world-changing refactor fully centralizes Memverse’s design tokens, theming, and test/dev/CI
mock behaviors. The app is now ready for easy rebrands, light/dark support, and zero-config local or
CI runs. All widget theming, tokens, and UX flows are totally DRY.

## Changes

- **Global Theming:**
    - All theme-related configuration (light/dark/feedback/card/nav/appbar/Button/etc) is now built
      from `themes.dart` tokens/constants.
    - BetterFeedback overlays dynamically match light/dark theme.
    - Extracted all paddings, radii, and durations into constants—no magic numbers remain in widget
      code.
- **Token-based Design System:**
    - All colors, spacings, typography, and radii live in `themes.dart`.
    - Added role-based color tokens and richer ColorScheme/TextTheme for modern design.
    - Fully commented usage guide is documented at the top of the theme file.
- **Mock/No-op Services for Dev/CI:**
    - If `CLIENT_ID` is missing or set to 'debug', all providers (auth, analytics, verse repo)
      inject a mock or no-op service by default.
    - This ensures all local, dev, and CI environments run seamlessly (no config env required).
- **Production Enforcement:**
    - Only in release does `CLIENT_ID` requirement enforce real backends/services.
- **Entry Point Refactor:**
    - All entry points (`main.dart`, `main_development.dart`, `main_staging.dart`) reliably funnel
      through the `App` widget and the new global theme—no direct widget-level themeing.
    - Removed duplicate navigation scaffold implementations and magic color overrides from GoRouter
      setups.
- **Best Practices Documentation:**
    - Added `themes.dart` usage guide and new best-practices doc in root.
    - Added `split_tokens_themes_info.md` as a resource for advanced design system scaling.

## Screenshots

- [x] Light theme: nav/card/buttons shown
- [x] Dark theme: nav/card/buttons shown

## How to test

- 🍃 Run any entrypoint—dev, test, CI, integration test, etc—no env vars required. The app works and
  uses fake/mock backends by default.
- 🕹️ Change theme tokens in `themes.dart` and see global effect.

## Checklist

- [x] All theme changes and new tokens in `themes.dart`
- [x] All direct styling removed from widgets
- [x] Major goldens and widget tests pass, no theme breakage
- [x] PR includes direct link to `split_tokens_themes_info.md` for future designers/devs.
- [x] CI and dev workflows now fully robust.

---
**Jira/Tech Debt Remediation:**
Upgrades the codebase for scaling/rebranding, ensures frictionless local/CI experience, and sets up
foundation for future multi-branding or automated design system testing.
