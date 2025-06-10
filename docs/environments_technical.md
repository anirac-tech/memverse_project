# 🌍 Memverse Environments - Technical Documentation

## Overview

Memverse operates across multiple environments to ensure quality, stability, and proper testing
before production releases.

## Environment Structure

### 🔧 Development Environment

- **Purpose**: Local development and feature work
- **API URL**: `https://api-dev.memverse.com`
- **Web URL**: `https://memverse-dev.netlify.app`
- **Analytics**: PostHog (shared project, filtered by environment)
- **Database**: Development database with test data
- **Features**: Debug logging enabled, development tools accessible

### 🧪 Staging Environment

- **Purpose**: Pre-production testing and QA validation
- **API URL**: `https://api-staging.memverse.com`
- **Web URL**: `https://memverse-staging.netlify.app`
- **Analytics**: PostHog (shared project, filtered by environment)
- **Database**: Staging database with production-like data
- **Features**: Production-like configuration with enhanced logging

### 🚀 Production Environment

- **Purpose**: Live user-facing application
- **API URL**: `https://api.memverse.com`
- **Web URL**: `https://memverse.com`
- **Analytics**: PostHog (shared project, production data only)
- **Database**: Production database with real user data
- **Features**: Optimized performance, minimal logging, error monitoring

## Technical Implementation

### Entry Points by Environment

```dart
// Development
main_development.dart -> AnalyticsEntryPoint.mainDevelopment

// Staging  
main_staging.dart -> AnalyticsEntryPoint.mainStaging

// Production
main_production.dart -> AnalyticsEntryPoint.mainProduction
```

### Environment Detection

```dart
enum AnalyticsEnvironment {
  production('prod', 'https://api.memverse.com'),
  staging('staging', 'https://api-staging.memverse.com'), 
  development('dev', 'https://api-dev.memverse.com');
}
```

### Analytics Properties Tracked

- `entry_point`: main_development, main_staging, main_production
- `app_flavor`: development, staging, production
- `environment`: dev, staging, prod
- `environment_api_url`: Full API endpoint URL
- `debug_mode`: true/false based on Flutter build mode
- `platform`: web, android, ios, etc.
- `is_emulator`/`is_simulator`: Device type detection

## Configuration Management

### Environment Variables

```bash
# PostHog Analytics
POSTHOG_MEMVERSE_API_KEY=ph_xxx

# API Configuration  
MEMVERSE_API_URL=https://api-dev.memverse.com

# Client Authentication
CLIENT_ID=your_client_id
```

### Build Commands by Environment

#### Development

```bash
# Web
flutter run --target lib/main_development.dart --dart-define=CLIENT_ID=$CLIENT_ID

# APK
flutter build apk --debug --target lib/main_development.dart --dart-define=CLIENT_ID=$CLIENT_ID
```

#### Staging

```bash
# Web
flutter run --target lib/main_staging.dart --dart-define=CLIENT_ID=$CLIENT_ID --dart-define=MEMVERSE_API_URL=https://api-staging.memverse.com

# APK
flutter build apk --target lib/main_staging.dart --dart-define=CLIENT_ID=$CLIENT_ID --dart-define=MEMVERSE_API_URL=https://api-staging.memverse.com
```

#### Production

```bash
# Web
flutter build web --target lib/main_production.dart --dart-define=CLIENT_ID=$CLIENT_ID --dart-define=MEMVERSE_API_URL=https://api.memverse.com

# APK  
flutter build apk --release --target lib/main_production.dart --dart-define=CLIENT_ID=$CLIENT_ID --dart-define=MEMVERSE_API_URL=https://api.memverse.com
```

## Deployment Pipeline

### 🔄 CI/CD Flow

1. **Development**: Automatic deployment to dev environment on main branch
2. **Staging**: Manual promotion from dev, automated testing
3. **Production**: Manual promotion from staging after QA approval

### 📊 Monitoring & Analytics

- **Development**: Full debug logging, all events tracked
- **Staging**: Production-like monitoring with enhanced visibility
- **Production**: Optimized tracking, error monitoring, performance metrics

## Future Enhancements

### 🎯 Planned Improvements

- [ ] Separate PostHog projects per environment for cleaner analytics
- [ ] Automated environment promotion workflows
- [ ] Enhanced error monitoring with Sentry integration
- [ ] Performance monitoring with Firebase Performance
- [ ] Feature flags for gradual rollouts

### 🔐 Security Considerations

- API keys managed via environment variables
- Separate databases per environment
- Production-only secrets and configurations
- Access control per environment level

## Troubleshooting

### Common Issues

1. **Wrong Environment**: Check `MEMVERSE_API_URL` environment variable
2. **Analytics Not Working**: Verify `POSTHOG_MEMVERSE_API_KEY` is set
3. **Build Failures**: Ensure `CLIENT_ID` is provided for all builds
4. **Web Deployment**: Confirm Netlify environment variables are configured

### Debug Commands

```bash
# Check current environment
flutter run --target lib/main_development.dart --dart-define=CLIENT_ID=$CLIENT_ID --verbose

# Verify analytics initialization
# Check logs for: "✅ Analytics initialized successfully"
```

## Contact & Support

For technical environment issues, contact the development team or create a ticket in the project
management system.