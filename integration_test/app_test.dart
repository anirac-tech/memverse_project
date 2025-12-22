import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;
import 'package:memverse/src/app/view/app.dart';
import 'package:memverse/src/features/settings/presentation/settings_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('navigate to settings and toggle dark mode', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify the app starts in light mode
      expect(tester.widget<App>(find.byType(App)).themeMode, ThemeMode.light);

      // Tap on the settings icon
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Verify we are on the settings screen
      expect(find.byType(SettingsScreen), findsOneWidget);

      // Tap the dark mode toggle
      await tester.tap(find.byKey(const Key('themeModeSwitch')));
      await tester.pumpAndSettle();

      // Verify the theme mode is now dark
      expect(tester.widget<App>(find.byType(App)).themeMode, ThemeMode.dark);

      // Tap the dark mode toggle again
      await tester.tap(find.byKey(const Key('themeModeSwitch')));
      await tester.pumpAndSettle();

      // Verify the theme mode is back to light
      expect(tester.widget<App>(find.byType(App)).themeMode, ThemeMode.light);
    });
  });
}
