# Simplify Environment Variable Management for Flutter App

## Story Description

**As a** developer working on the Memverse Flutter app  
**I want** to simplify the management of environment variables for dart-define parameters  
**So that** I don't have to manually pass multiple --dart-define flags every time I run the app

## Background

Currently, running the app requires multiple --dart-define parameters:

```bash
flutter run --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY --dart-define=MEMVERSE_CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY --flavor development --target lib/main_development.dart
```

This is verbose and error-prone. We should simplify this process while maintaining security.

## Acceptance Criteria

### Core Requirements

- [ ] **AC1**: Create a system to load dart-define values from a file
- [ ] **AC2**: Support reading environment variables from .zshrc/.bashrc (like $MEMVERSE_CLIENT_ID)
- [ ] **AC3**: File can be safely checked into repo since it references env vars, not actual secrets
- [ ] **AC4**: Reduce flutter run command to a simple single command
- [ ] **AC5**: Maintain compatibility with CI/CD build processes

### Technical Implementation Options

#### Option 1: Simple .env File with Script

- Create `env/development.env` file with contents like:
  ```
  CLIENT_ID=$MEMVERSE_CLIENT_ID
  POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY  
  MEMVERSE_CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY
  ```
- Create shell script that reads file and builds dart-define flags
- Safe to commit since it references env vars, not actual values

#### Option 2: Flutter-native approach with --dart-define-from-file

- Use Flutter's built-in `--dart-define-from-file` flag
- Create JSON file with environment variable references
- Example: `env/development.json`

#### Option 3: Use envied package

- Add `envied` package for compile-time environment variable injection
- Generate type-safe environment variable classes
- More complex but provides better DX and type safety

### Stretch Goals

- [ ] **SG1**: Integrate with 1Password CLI for secret management
- [ ] **SG2**: Support multiple environments (dev, staging, prod) with different env files
- [ ] **SG3**: Add validation to ensure required environment variables are set
- [ ] **SG4**: Create VS Code launch configurations using the simplified setup

## Technical Research

Reference: https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/

### Current Pain Points

1. Long command line with multiple --dart-define flags
2. Easy to forget or mistype environment variable names
3. No central place to see what env vars are required
4. Difficult for new developers to set up correctly

### Proposed Solution Structure

```
env/
├── development.env     # Development environment variables
├── staging.env        # Staging environment variables (future)
└── production.env     # Production environment variables (future)

scripts/
├── run_dev.sh         # Simple script: flutter run with all dev flags
└── build_dev.sh       # Simple script: flutter build with all dev flags
```

## Definition of Done

- [ ] Developer can run app with single simple command
- [ ] Environment file is safely committable to repo
- [ ] CI/CD builds continue to work without changes
- [ ] Documentation updated in setup.md
- [ ] All team members can use new system without additional setup

## Priority

**Medium** - Developer experience improvement, not blocking functionality

## Estimate

**5 Story Points** - Requires research, implementation, testing, and documentation updates

## Labels

- `developer-experience`
- `tooling`
- `environment-setup`
- `technical-debt`