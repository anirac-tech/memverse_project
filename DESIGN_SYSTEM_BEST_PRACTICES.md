# Flutter Design System Best Practices (Memverse)

## 1. Centralize Everything

- **All spacing, color, typography, radius, and animation values should be tokens/constants in one
  place.**
- ThemeData (for MaterialApp) should be the only place widget styles and themes are constructed.
- Never use raw numbers or Colors.* in a widget file—import from a tokens or theme file.

## 2. Use TextTheme, ColorScheme, And Token Names

- Always reference text styles via Theme.of(context).textTheme (never fontSize/fontWeight in
  widgets).
- Use ColorScheme roles where possible, e.g., primary, secondary, error, background, onPrimary, etc.
- If you have your own brand tokens (e.g., kBrandAccent), use them for mapping to ColorScheme.

## 3. DRY Spacing and Sizing

- If a widget requires custom padding, always use named constants (`kPadding`, `kVerticalPadding`,
  etc.).
- Define card radii, button radii, and elevations as global constants for consistency.

## 4. Tests Should Use Theme

- Widget tests should set up MaterialApp using AppThemes.light or AppThemes.dark.
- Test golden rendering for all major components in both light/dark modes.
- Prefer test IDs/Keys linked to logical names, not raw widget types.

## 5. Light, Dark, and Brand Scalability

- For every ThemeData, provide both a light and dark mode. Adjust Feedback/Banner overlays to match.
- Consider supporting multiple brands/locales via token split (`memverse_tokens.dart`, see
  split_tokens_themes_info.md).
- Favor color names that are role-based ("primary", "onPrimary", "surface", etc.) over color
  hex/brand names.

## 6. Linting and Pull Request Process

- Enforce `dart fix --apply`, and `flutter analyze` before all PRs.
- No magic numbers or new colors allowed outside theme/tokens files.
- PR template should require a checklist for token changes, golden test updates, and design review.

## 7. Documentation and Collaboration

- Keep theme/tokens files well commented—list what roles are/aren’t mapped.
- All designers/devs agree to update only these centralized files for any design change.
- Keep a 'how-to' doc at the top of these files for easy onboarding.

---
See `split_tokens_themes_info.md` for advanced design system scaling tips and future-proofing.
