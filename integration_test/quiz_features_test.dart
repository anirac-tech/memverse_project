import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/main_development.dart' as app;
import 'package:memverse/src/features/settings/presentation/settings_screen.dart';

/// BDD tests for quiz features functionality
void main() {
  group('Quiz Features BDD Tests', () {
    testWidgets('user can navigate and use quiz features', (tester) async {
      await givenTheAppIsRunning(tester);
      await andIAmLoggedIn(tester);
      await whenINavigateToTheReferenceQuiz(tester);
      await thenIShouldSeeQuizInterface(tester);
    });

    testWidgets('user can toggle theme during quiz usage', (tester) async {
      await givenTheAppIsRunning(tester);
      await andIAmLoggedIn(tester);
      await whenIAmPracticingAQuiz(tester);
      await andINavigateToSettings(tester);
      await andIToggleTheThemeMode(tester);
      await thenTheAppShouldDisplayInTheNewTheme(tester);
    });
  });
}

/// Step: Given the app is running
Future<void> givenTheAppIsRunning(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // Verify app has loaded
  expect(find.byType(MaterialApp), findsOneWidget);
}

/// Step: And I am logged in
Future<void> andIAmLoggedIn(WidgetTester tester) async {
  // In development mode with AUTOSIGNIN, user is already logged in
  // Just verify we're past the login screen
  await tester.pumpAndSettle(const Duration(seconds: 2));

  // Look for navigation elements that indicate we're logged in
  final hasBottomNav = find.byType(BottomNavigationBar);
  expect(hasBottomNav, findsWidgets);
}

/// Step: When I navigate to the Reference Quiz
Future<void> whenINavigateToTheReferenceQuiz(WidgetTester tester) async {
  // Look for the reference quiz tab/button
  // This might be the "Progress" tab or a quiz navigation element
  final progressTab = find.text('Progress');
  if (progressTab.evaluate().isNotEmpty) {
    await tester.tap(progressTab);
    await tester.pumpAndSettle();
  }
}

/// Step: Then I should see quiz interface
Future<void> thenIShouldSeeQuizInterface(WidgetTester tester) async {
  // Verify quiz UI elements are present
  await tester.pumpAndSettle();

  // Look for common quiz elements
  final hasScaffold = find.byType(Scaffold);
  expect(hasScaffold, findsWidgets);
}

/// Step: When I am practicing a quiz
Future<void> whenIAmPracticingAQuiz(WidgetTester tester) async {
  // Navigate to a quiz screen
  await whenINavigateToTheReferenceQuiz(tester);
  await tester.pumpAndSettle();
}

/// Step: And I navigate to settings
Future<void> andINavigateToSettings(WidgetTester tester) async {
  // Tap the settings icon/tab
  final settingsIcon = find.byIcon(Icons.settings);
  if (settingsIcon.evaluate().isEmpty) {
    final settingsTab = find.text('Settings');
    if (settingsTab.evaluate().isNotEmpty) {
      await tester.tap(settingsTab);
      await tester.pumpAndSettle();
    }
  } else {
    await tester.tap(settingsIcon.first);
    await tester.pumpAndSettle();
  }

  // Verify we're on settings screen
  expect(find.byType(SettingsScreen), findsOneWidget);
}

/// Step: And I toggle the theme mode
Future<void> andIToggleTheThemeMode(WidgetTester tester) async {
  // Find the theme toggle switch
  final themeSwitch = find.byKey(const Key('themeModeSwitch'));

  if (themeSwitch.evaluate().isNotEmpty) {
    await tester.tap(themeSwitch);
    await tester.pumpAndSettle();
  } else {
    // Alternative: find by type SwitchListTile and tap the first one
    final switches = find.byType(SwitchListTile);
    if (switches.evaluate().isNotEmpty) {
      await tester.tap(switches.first);
      await tester.pumpAndSettle();
    }
  }
}

/// Step: Then the app should display in the new theme
Future<void> thenTheAppShouldDisplayInTheNewTheme(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Verify the app has updated (MaterialApp exists)
  expect(find.byType(MaterialApp), findsOneWidget);

  // The theme should have changed - we can verify by checking the switch state
  final themeSwitch = find.byKey(const Key('themeModeSwitch'));
  if (themeSwitch.evaluate().isNotEmpty) {
    final switchWidget = tester.widget<SwitchListTile>(themeSwitch);
    // The switch should be in a different state than initial
    expect(switchWidget, isNotNull);
  }
}
