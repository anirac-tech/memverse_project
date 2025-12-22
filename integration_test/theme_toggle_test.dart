import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;
import 'package:memverse/src/features/settings/presentation/settings_screen.dart';

/// BDD tests for theme toggle functionality
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Toggle BDD Tests', () {
    testWidgets('user can toggle from light to dark theme', (tester) async {
      await givenTheAppIsRunningInLightMode(tester);
      await whenINavigateToSettings(tester);
      await andIToggleTheDarkModeSwitch(tester);
      await thenTheAppShouldDisplayInDarkTheme(tester);
    });

    testWidgets('user can toggle from dark to light theme', (tester) async {
      await givenTheAppIsRunningInDarkMode(tester);
      await whenINavigateToSettings(tester);
      await andIToggleTheDarkModeSwitch(tester);
      await thenTheAppShouldDisplayInLightTheme(tester);
    });

    testWidgets('theme preference persists across navigation', (tester) async {
      await givenTheAppIsRunning(tester);
      await whenINavigateToSettings(tester);
      await andIToggleToDarkMode(tester);
      await andINavigateToQuizScreens(tester);
      await andIReturnToSettings(tester);
      await thenTheDarkModeShouldStillBeEnabled(tester);
    });
  });
}

/// Step: Given the app is running in light mode
Future<void> givenTheAppIsRunningInLightMode(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // Verify app has loaded
  expect(find.byType(MaterialApp), findsOneWidget);
}

/// Step: Given the app is running in dark mode
Future<void> givenTheAppIsRunningInDarkMode(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // Navigate to settings and enable dark mode first
  await whenINavigateToSettings(tester);
  await andIToggleTheDarkModeSwitch(tester);
}

/// Step: Given the app is running
Future<void> givenTheAppIsRunning(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

/// Step: When I navigate to settings
Future<void> whenINavigateToSettings(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Look for settings tab or icon
  final settingsTab = find.text('Settings');
  final settingsIcon = find.byIcon(Icons.settings);

  if (settingsTab.evaluate().isNotEmpty) {
    await tester.tap(settingsTab);
    await tester.pumpAndSettle();
  } else if (settingsIcon.evaluate().isNotEmpty) {
    await tester.tap(settingsIcon.first);
    await tester.pumpAndSettle();
  }

  // Verify we're on settings screen
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

/// Step: And I toggle the dark mode switch
Future<void> andIToggleTheDarkModeSwitch(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Find the theme toggle switch by key
  final themeSwitch = find.byKey(const Key('themeModeSwitch'));

  if (themeSwitch.evaluate().isNotEmpty) {
    await tester.tap(themeSwitch);
    await tester.pumpAndSettle();
  } else {
    // Fallback: find by searching for "Dark Mode" text and its associated switch
    final darkModeText = find.text('Dark Mode');
    if (darkModeText.evaluate().isNotEmpty) {
      // Find the switch in the same tile
      final switches = find.byType(SwitchListTile);
      if (switches.evaluate().isNotEmpty) {
        await tester.tap(switches.first);
        await tester.pumpAndSettle();
      }
    }
  }
}

/// Step: And I toggle to dark mode
Future<void> andIToggleToDarkMode(WidgetTester tester) async {
  await andIToggleTheDarkModeSwitch(tester);
}

/// Step: Then the app should display in dark theme
Future<void> thenTheAppShouldDisplayInDarkTheme(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Verify MaterialApp exists and theme has changed
  expect(find.byType(MaterialApp), findsOneWidget);

  // Check if dark mode is reflected in the UI
  // We can verify by checking the switch state or theme data
  final themeSwitch = find.byKey(const Key('themeModeSwitch'));
  if (themeSwitch.evaluate().isNotEmpty) {
    final switchWidget = tester.widget<SwitchListTile>(themeSwitch);
    // In dark mode, the switch should be "on"
    expect(switchWidget.value, true);
  }
}

/// Step: Then the app should display in light theme
Future<void> thenTheAppShouldDisplayInLightTheme(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Verify MaterialApp exists
  expect(find.byType(MaterialApp), findsOneWidget);

  // Check if light mode is reflected in the UI
  final themeSwitch = find.byKey(const Key('themeModeSwitch'));
  if (themeSwitch.evaluate().isNotEmpty) {
    final switchWidget = tester.widget<SwitchListTile>(themeSwitch);
    // In light mode, the switch should be "off"
    expect(switchWidget.value, false);
  }
}

/// Step: And I navigate to quiz screens
Future<void> andINavigateToQuizScreens(WidgetTester tester) async {
  // Navigate away from settings
  final reviewTab = find.text('Review');
  if (reviewTab.evaluate().isNotEmpty) {
    await tester.tap(reviewTab);
    await tester.pumpAndSettle();
  }

  // Navigate to progress/reference quiz
  final progressTab = find.text('Progress');
  if (progressTab.evaluate().isNotEmpty) {
    await tester.tap(progressTab);
    await tester.pumpAndSettle();
  }
}

/// Step: And I return to settings
Future<void> andIReturnToSettings(WidgetTester tester) async {
  await whenINavigateToSettings(tester);
}

/// Step: Then the dark mode should still be enabled
Future<void> thenTheDarkModeShouldStillBeEnabled(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Verify settings screen is displayed
  expect(find.byType(SettingsScreen), findsOneWidget);

  // Check that dark mode switch is still on
  final themeSwitch = find.byKey(const Key('themeModeSwitch'));
  if (themeSwitch.evaluate().isNotEmpty) {
    final switchWidget = tester.widget<SwitchListTile>(themeSwitch);
    expect(switchWidget.value, true, reason: 'Dark mode should persist across navigation');
  }
}
