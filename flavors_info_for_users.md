# Memverse App Flavors - Information for Users

## What are App Flavors?

App flavors are different versions of the same application that can be installed on your device.
Each flavor serves a specific purpose and is targeted at different users and stages of the
application lifecycle.

## Memverse Flavors

### Development Version

**Purpose**: Internal testing by developers

**Characteristics**:

- Contains experimental features that may not be fully tested
- May include debugging tools and log output
- Can be less stable than other versions
- Has a different app icon with a "[DEV]" banner in the corner
- App name appears as "[DEV] Memverse" on your device
- Often connects to development/test servers rather than production

**Who should use it**: Only the development team or internal testers who are specifically asked to
test this version.

### Staging Version

**Purpose**: Pre-release testing and quality assurance

**Characteristics**:

- More stable than the development version
- Features are more complete and tested
- May contain analytics and bug reporting tools not present in the production version
- Has a different app icon with a "[STG]" banner in the corner
- App name appears as "[STG] Memverse" on your device
- Usually connects to staging servers that mimic the production environment
- May be distributed through TestFlight (iOS) or internal test tracks on Google Play

**Who should use it**: Beta testers, quality assurance teams, and stakeholders reviewing features
before public release.

### Production Version

**Purpose**: Public release version

**Characteristics**:

- Fully tested and stable version
- All features are complete and working as expected
- Optimized for performance and user experience
- No visible debugging information
- Standard app icon without any special banners
- App name appears simply as "Memverse" on your device
- Connects to production servers and services
- Distributed through the App Store and Google Play Store

**Who should use it**: All end users who are not part of the testing or development process.

## Identifying Your Version

You can check which version of Memverse you're using by:

1. Looking at the app name on your device - different flavors have different names:
    - "[DEV] Memverse" - Development version
    - "[STG] Memverse" - Staging version
    - "Memverse" - Production version

2. Looking at the app icon - development and staging versions have visual indicators in the corner
   of the app icon

3. Checking the app version in Settings > About screen, which may indicate the flavor

## Reporting Issues

When reporting issues or providing feedback, always mention which version (flavor) of the app you're
using, as this helps the development team identify and resolve issues more effectively.

For beta testers using Development or Staging flavors, please use the in-app feedback tool to report
issues, as this automatically captures important diagnostic information.

## Why Multiple Versions?

Having multiple flavors helps the development team to:

1. Test new features without affecting the experience of regular users
2. Maintain multiple environments (development, staging, production) with different configurations
3. Allow for different levels of logging and debugging based on the environment
4. Enable internal testing before public release
5. Keep analytics and error reporting data separate between testing and live usage

## External Resources

To learn more about app flavors and why they're important in app development:

- [Flutter Documentation - Flavors](https://docs.flutter.dev/deployment/flavors)
- [What are Flavors in App Development?](https://www.codewithandrea.com/articles/flutter-flavors-for-non-developers/)