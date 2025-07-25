# Memverse

![coverage][coverage_badge]
![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/anirac-tech/memverse_project)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Scripture Memory mobile front end for www.memverse.com

---

## Getting Started

**This project requires you to set several environment variables before building or running:**

- `CLIENT_ID` (required for all builds and app functionality)
- `POSTHOG_MEMVERSE_API_KEY` (required for analytics)

These should be set in your shell profile (e.g., `.zshrc`) or via your secrets manager.

**Reference:** See `setup.md` for detailed environment setup.

### Run and Build Commands (Android, development flavor)

```sh
# Build debug APK:
flutter build apk --debug \
  --flavor development \
  --target lib/main_development.dart \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY

# Install to connected device:
flutter install --debug \
  --flavor development \
  --target lib/main_development.dart \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY

# Run (use these dart-defines, with your env vars!):
flutter run \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY \
  --flavor development \
  --target lib/main_development.dart \
  --dart-define=AUTOSIGNIN=true
```

**AUTOSIGNIN FOR DEMOING**

- By default (AUTOSIGNIN=true), the app skips login and shows a fully interactive mock/dummy UI for
  the account dummysigninuser@dummy.com. Use this for QA, Maestro tests, and visual review.
- For real authentication (testing actual backend login), set `--dart-define=AUTOSIGNIN=false` when
  running, building, or installing the app.

## Demo/QA Example - Autosignin

```sh
flutter run --flavor development --target lib/main_development.dart \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=MEMVERSE_CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY \
  --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY \
  --dart-define=AUTOSIGNIN=true
```

## Real-World Use - No Autosignin

```sh
flutter run --flavor development --target lib/main_development.dart \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=MEMVERSE_CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY \
  --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY \
  --dart-define=AUTOSIGNIN=false
```

**Note:**

- Never use `lib/main.dart` as your target; always use `main_development.dart` for development.
- All Android builds must use `--flavor development` for proper configuration.
- App will not function if required env variables are missing.
- Production and staging use different entrypoints and vars.

## Maestro Testing

- The included Maestro flows will work out of the box with `AUTOSIGNIN=true`, so the login screen
  will be skipped and dummy/mock UI will be shown for screenshot and tab navigation tests.
- For login form tests, run Maestro with `--dart-define=AUTOSIGNIN=false`.

For Maestro testing or more platform-specific notes, see `maestro_rules.txt` and `setup.md`.

