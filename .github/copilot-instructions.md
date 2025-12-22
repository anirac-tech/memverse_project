# AI Agent Instructions for Memverse Codebase

This document guides AI agents on the essential architecture, patterns, and workflows for productive
development in the Memverse project.

## Project Overview

Memverse is a Flutter-based Scripture memory mobile application (`lib/main_development.dart`,
`lib/main_production.dart`) with:

- **State Management**: Riverpod with hooks (`flutter_hooks`, `hooks_riverpod`, `flutter_riverpod`)
- **Core Features**: Authentication, verse/reference quizzing, user practice sessions
- **Testing Strategy**: BDD via `bdd_widget_test`, unit tests via `mocktail`, golden tests, Maestro
  E2E tests
- **Analytics**: PostHog (conditional), Talker for logging
- **APIs**: Memverse REST API (critical: different base URLs for OAuth vs other endpoints)

## Critical Architecture Patterns

### 1. Environment-Dependent Behavior

**AUTOSIGNIN Flow**: The app supports two modes controlled by `--dart-define=AUTOSIGNIN`:

- `true` (default): Skips login, uses dummy user (`dummysigninuser@dummy.com`),
  `AuthService.isDummyUser = true`
- `false`: Real OAuth flow with actual backend

**Launch Points** (`lib/main_*.dart`):

- `main_development.dart`: Development API endpoints
- `main_staging.dart`: Staging API endpoints
- `main_production.dart`: Production API endpoints
- Always use development entry point for local work; never use `lib/main.dart`

**Required Environment Variables** (set in shell profile, e.g., `~/.zshrc`):

- `CLIENT_ID`: OAuth client ID (required for all builds)
- `MEMVERSE_CLIENT_API_KEY`: Bearer token auth for signup endpoint
- `POSTHOG_MEMVERSE_API_KEY`: Analytics key

### 2. Critical API Endpoint Routing

**OAuth endpoints use DIFFERENT base URLs than other API endpoints** — this is the #1 source of auth
bugs (remember this!):

```dart
// Native platforms: https://www.memverse.com/oauth/token (root level, NOT /api/v1/)
// Web platforms: /oauth/token (via Netlify proxy)
// Other API calls: https://www.memverse.com/api/v1/* (native) or /api/* (web)
```

See `lib/src/features/auth/data/auth_service.dart` for platform-specific routing logic.

### 3. Riverpod State Management

**Core Providers** (`lib/src/features/auth/presentation/providers/auth_providers.dart`):

- `authStateProvider`: StateNotifierProvider managing authentication state
- `isLoggedInProvider`: FutureProvider for checking login status
- `accessTokenProvider` / `bearerTokenProvider`: Derived providers for API headers
- `clientIdProvider`: Provides bootstrap CLIENT_ID across the app
- `authServiceProvider`: Singleton AuthService instance

**Widget Consumption Pattern**:

- Use `HookConsumerWidget` for reactive UI (preferred)
- Use `ref.watch()` for listening to providers (updates on change)
- Use `ref.read()` for one-time reads (e.g., for API calls)
- Override providers in tests via `ProviderScope(overrides: [...])`

Example from `lib/src/features/auth/presentation/auth_wrapper.dart`:

```dart
class AuthWrapper extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.isAuthenticated ? MemversePage() : LoginPage();
  }
}
```

### 4. Feature Module Structure

Each feature lives in `lib/src/features/{feature_name}/`:

```
auth/
  data/
    auth_service.dart       # Business logic, external APIs
    auth_api.dart          # Retrofit API client
  domain/
    auth_token.dart        # Data models
  presentation/
    providers/
      auth_providers.dart  # Riverpod providers, state notifiers
    login_page.dart        # UI widgets (HookConsumerWidget)
    auth_wrapper.dart      # Auth guards, routing logic

verse/
  data/
    verse_repository.dart  # Repository pattern, API calls
  domain/
    verse.dart             # Domain models
  presentation/
    memverse_page.dart     # Main quiz UI
```

**Key Pattern**: Data layer exposes Riverpod providers; presentation consumes them.

### 5. Testing Architecture

**Unit Tests** (`test/` directory):

- Use `ProviderContainer` for provider testing: `ProviderContainer(overrides: [...])`
- Use `FakeVerseRepository` (not real API calls) for integration tests
- Mock external dependencies via `mocktail`
- **Logging Standard**: Never use `debugPrint()` or `log()` — use `AppLogger.d/i/w/e` (enforced by
  `scripts/check_logging_standards.py`)

**Widget Tests** (`test/` with BDD):

- Use `bdd_widget_test` framework with given/when/then semantics
- Override providers in test setup: `ProviderScope(overrides: [...])`
- See `test/step/the_app_is_running.dart` for setup examples

**Golden Tests** (`test/golden_tests/`):

- Capture baseline screenshots: `flutter test --update-goldens --tags golden`
- Run without updating: `flutter test --tags golden`
- Generate HTML diff report: `./scripts/generate_golden_report.sh`

**Integration Tests** (`integration_test/`):

- Real app with mocked repositories
- See `integration_test/step/the_app_is_running.dart`

**Maestro E2E Tests** (`maestro/`):

- Require real app install:
  `flutter install --flavor development --target lib/main_development.dart`
- Run with autosignin: No login screen required
- Rules in `maestro_rules.txt`

## Critical Build & Run Workflow

### Development Build (Most Common)

```bash
# Run with hot reload (autosignin = true, skips login)
flutter run \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY \
  --flavor development \
  --target lib/main_development.dart \
  --dart-define=AUTOSIGNIN=true

# Install to device
flutter install --debug \
  --flavor development \
  --target lib/main_development.dart \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID

# Test with real login
flutter run \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=MEMVERSE_CLIENT_API_KEY=$MEMVERSE_API_KEY \
  --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY \
  --dart-define=AUTOSIGNIN=false \
  --flavor development \
  --target lib/main_development.dart
```

### Testing Commands

```bash
# All unit tests
flutter test

# With coverage
flutter test --coverage

# Golden tests only
flutter test --tags golden --update-goldens

# Integration tests
flutter test integration_test/

# BDD tests
flutter test test/
```

## Project-Specific Conventions

### 1. Logging Standards

- **Use `AppLogger` class only** (`lib/src/utils/app_logger.dart`)
- Methods: `AppLogger.d()`, `AppLogger.i()`, `AppLogger.w()`, `AppLogger.e()`
- **Never use** `debugPrint()` or `log()` from `dart:developer`
- Violations auto-fixed by `scripts/check_logging_standards.py --mode local --auto-fix`

### 2. Code Style & Formatting

- `dart format . -l 100` enforces 100-char line limit
- `dart fix --apply` for automated analyzer fixes
- `flutter analyze` checks for violations
- Enforce via pre-commit hook: `./scripts/setup_git_hooks.sh`
- Linting: `very_good_analysis` (version 9.0.0)

### 3. Design System

- All spacing, colors, typography in `lib/src/constants/themes.dart`
- Use `Theme.of(context).textTheme` and `ColorScheme` (never raw `fontSize`, `Colors.blue`)
- Dark mode support via `ThemeMode.system`
- See `DESIGN_SYSTEM_BEST_PRACTICES.md` for token strategy

### 4. Dependency Injection Pattern

- No service locator; use Riverpod providers instead
- For testing: `ProviderScope(overrides: [...])` is the standard pattern
- Example: Override repository in tests to return fake data

### 5. Provider Overrides for Testing

```dart
// Standard test pattern
final container = ProviderContainer(
  overrides: [
    verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
    analyticsServiceProvider.overrideWith((ref) => LoggingAnalyticsService()),
  ],
);
```

## Data Flow & API Integration

### Authentication Flow

1. **Bootstrap** (`lib/src/bootstrap.dart`): Initializes `bootstrapProvider` with CLIENT_ID
2. **AuthService** (`lib/src/features/auth/data/auth_service.dart`): Handles OAuth token exchange,
   secure storage
3. **AuthNotifier** (`auth_providers.dart`): Manages auth state, exposes `authStateProvider`
4. **AuthWrapper** (`auth_presentation.dart`): Routes to login or main app based on auth state
5. **Token Injection**: `bearerTokenProvider` used in API interceptors for authenticated requests

### Verse Data Flow

1. **VerseRepository** (`lib/src/features/verse/data/verse_repository.dart`): Fetches from Memverse
   API
2. **Providers**: `verseRepositoryProvider` exposes repository, `verseListProvider` fetches verse
   list
3. **MemversePage** (`lib/src/features/verse/presentation/memverse_page.dart`): Consumes
   `verseListProvider`, renders quiz UI

### Analytics Integration

- **AnalyticsService** (`lib/src/common/services/analytics_service.dart`): Abstract base with three
  implementations
    - `PostHogAnalyticsService`: Real analytics in production
    - `LoggingAnalyticsService`: Dev/test logging only
    - `NoOpAnalyticsService`: Silent (fallback)
- **Initialization**: Conditional on `POSTHOG_MEMVERSE_API_KEY` availability

## When Making Changes

### Adding a New Feature

1. Create folder: `lib/src/features/{feature_name}/{data,domain,presentation}/`
2. Define domain models in `domain/`
3. Create repository/service in `data/` with Riverpod provider
4. Create UI widgets in `presentation/` as `HookConsumerWidget`
5. Add providers to `presentation/providers/` file
6. Create tests: `test/features/{feature_name}/` with same structure

### Modifying Auth Flow

- **Always check**: `lib/src/features/auth/data/auth_service.dart` for API endpoint base URLs
- Update both OAuth endpoint (`authApi baseUrl`) and regular API calls
- Test with `AUTOSIGNIN=false` to verify real login still works
- Golden tests should cover both login and post-login states

### Adding API Endpoints

1. Extend `AuthApi` or create new Retrofit API client in `data/`
2. Ensure correct base URL: OAuth at root, other endpoints at `/api/v1/`
3. Inject bearer token via `bearerTokenProvider` in interceptor
4. Create repository that wraps API calls
5. Expose via Riverpod provider in presentation layer

### Updating UI/Theme

1. Add tokens to `lib/src/constants/themes.dart`
2. Update `ThemeData` configurations (light/dark modes)
3. **Never** hardcode colors, spacing, or font sizes in widgets
4. Create golden test for new component in both light/dark modes
5. Update `DESIGN_SYSTEM_BEST_PRACTICES.md` if adding new token categories

## Key Files & Their Purposes

| File                                                               | Purpose                                         |
|--------------------------------------------------------------------|-------------------------------------------------|
| `lib/main_development.dart`                                        | Entry point for development flavor              |
| `lib/src/bootstrap.dart`                                           | App initialization, DI container setup          |
| `lib/src/app/view/app.dart`                                        | Root widget, theme config, Talker setup         |
| `lib/src/features/auth/data/auth_service.dart`                     | OAuth flow, token storage, critical API routing |
| `lib/src/features/auth/presentation/providers/auth_providers.dart` | Auth state management (StateNotifierProvider)   |
| `lib/src/features/verse/data/verse_repository.dart`                | Verse data fetching, Riverpod provider          |
| `lib/src/constants/themes.dart`                                    | All design tokens, theme configurations         |
| `lib/src/utils/app_logger.dart`                                    | Logging utility (use instead of debugPrint)     |
| `scripts/check_logging_standards.py`                               | Enforces AppLogger usage                        |
| `test/step/the_app_is_running.dart`                                | Standard test setup with provider overrides     |
| `maestro_rules.txt`                                                | E2E testing rules & best practices              |

## Common Debugging Patterns

**Auth Not Working**

- Check: Is `CLIENT_ID` set? `echo $MEMVERSE_CLIENT_ID`
- Check: Is `MEMVERSE_CLIENT_API_KEY` set for signup?
- Check: Is OAuth endpoint using root-level URL, not `/api/v1/`?
- Use `curl` logs from `CurlLoggingInterceptor` in app logs

**Provider Not Updating**

- Use `ref.watch()` not `ref.read()` for reactive updates
- Check: Is provider override in test? Use `ProviderContainer(overrides: [...])`
- Debug: Use `TalkerRiverpodObserver` (already configured in bootstrap)

**Golden Test Failing**

- Update baseline: `flutter test --tags golden --update-goldens`
- Review diff: `./scripts/generate_golden_report.sh` opens HTML report
- Theme mismatch? Ensure test uses `AppThemes.light` / `AppThemes.dark`

**Maestro Tests Failing**

- Ensure app installed: `flutter install --flavor development --target lib/main_development.dart`
- Use autosignin for simple tests, set `AUTOSIGNIN=false` only for login flow tests
- Check device permission logs; Maestro may need accessibility permissions

## References

- **Testing Guide**: `test/README.md`
- **Setup Instructions**: `setup.md`
- **E2E Testing**: `maestro_rules.txt`, `maestro/README.md`
- **Design System**: `DESIGN_SYSTEM_BEST_PRACTICES.md`, `split_tokens_themes_info.md`
- **Release Process**: `RELEASE_NOTES.md`, `manual_android_*.md`
