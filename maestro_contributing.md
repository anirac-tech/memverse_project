# Maestro Contributing Guide for Flutter Testing

## Quick Start

### Basic Text Input Approach

For simple, readable tests, use the text-based approach:

```yaml
- tapOn: "Enter your username"
- inputText: "charlie_root"
```

This taps on text visible to the user and then inputs text.

### Using Semantics Identifiers (Recommended)

For more robust tests, use semantic identifiers:

```yaml
- tapOn:
    id: "login_username_field"
- inputText: "charlie_root"
```

## Element Identification Approaches

### 1. Semantics Label vs Semantics Identifier

#### Semantics Label

- **What it is**: The `label` property in Flutter's `Semantics` widget
- **Purpose**: Accessibility text read aloud by screen readers
- **Localized**: Yes, changes with app language
- **In Maestro**: Use with `text:` selector
- **Example**:

```dart
Semantics(
  label: 'Username field', // This is localized and read by screen readers
  child: TextField(),
)
```

```yaml
- tapOn:
    text: "Username field"
```

#### Semantics Identifier (New in Flutter 3.19+)

- **What it is**: The `identifier` property in Flutter's `Semantics` widget (thanks to Bartek
  Pacia's contribution)
- **Purpose**: Testing-only identifier, NOT read by screen readers
- **Localized**: No, stable across languages
- **In Maestro**: Use with `id:` selector
- **Example**:

```dart
Semantics(
  identifier: 'login_username_field', // Stable test identifier
  label: 'Username field', // User-facing, localized text
  child: TextField(),
)
```

```yaml
- tapOn:
    id: "login_username_field"
```

### 2. Native Android/iOS IDs

#### Android resource-id

Maps to Android's native `resource-id` attribute visible in UI Automator.

#### iOS accessibility identifier

Maps to iOS's native `accessibilityIdentifier` property.

## FAQ

### Q: When should I use text vs id selectors?

**A:** Use `id:` selectors for:

- Production tests that need to be stable across UI changes
- Multi-language apps
- Elements that might change text frequently

Use `text:` selectors for:

- Quick prototyping
- Tests where readability is more important than stability
- Static text that won't change

### Q: What if my Flutter version is below 3.19?

**A:** Use the `label` property instead of `identifier`, but be aware it will be read by screen
readers and may be localized.

### Q: How do I find existing identifiers in my app?

**A:**

1. Use Maestro Studio to inspect elements
2. Check your Flutter code for `Semantics` widgets with `identifier` or `label` properties
3. Use Android UI Automator Viewer or iOS Accessibility Inspector

### Q: What's the difference between Flutter Keys and Semantics identifiers?

**A:**

- **Flutter Keys**: Internal Flutter identifiers, not exposed to native accessibility tree
- **Semantics identifiers**: Exposed to native accessibility, visible to UI testing tools

## Advanced Topics

### Custom Semantic Properties

You can combine multiple semantic properties:

```dart
Semantics(
  identifier: 'submit_button',
  label: 'Submit Form',
  hint: 'Tap to submit the form',
  button: true,
  child: ElevatedButton(),
)
```

### Testing Different Platforms

Remember that the same semantic identifier works across platforms:

- Android: Shows as `resource-id`
- iOS: Shows as `accessibilityIdentifier`
- Maestro: Use `id:` selector for both

### Best Practices

1. Use descriptive, stable identifiers (e.g., `login_username_field` not `field1`)
2. Don't use identifiers for text that should be read by screen readers
3. Combine identifiers with labels for both accessibility and testing
4. Use consistent naming conventions across your app
5. Document your identifier patterns for the team

## References

- [Flutter Semantics Documentation](https://api.flutter.dev/flutter/widgets/Semantics-class.html)
- [Maestro Flutter Support](https://docs.maestro.dev/platform-support/flutter)
- [Bartek Pacia's Flutter Contribution](https://blog.mobile.dev/the-power-of-open-source-making-maestro-work-better-with-flutter-d92b386f9a33)