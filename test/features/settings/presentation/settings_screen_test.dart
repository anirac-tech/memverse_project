import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:memverse/src/features/settings/presentation/settings_screen.dart';

void main() {
  group('Settings Screen Golden Tests', () {
    testGoldens('Light Mode', (tester) async {
      await loadAppFonts();
      final builder = DeviceBuilder()
        ..addScenario(
          widget: const ProviderScope(child: MaterialApp(home: SettingsScreen())),
          name: 'light_mode',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'settings_screen_light');
    });

    testGoldens('Dark Mode', (tester) async {
      await loadAppFonts();
      final builder = DeviceBuilder()
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp(theme: ThemeData.dark(), home: const SettingsScreen()),
          ),
          name: 'dark_mode',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'settings_screen_dark');
    });
  });
}
