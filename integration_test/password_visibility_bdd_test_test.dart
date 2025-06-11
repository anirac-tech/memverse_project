import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'step/password_visibility_steps.dart';
import 'step/the_app_is_running.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Password Visibility BDD Tests', () {
    testWidgets('Toggle password visibility to show', (tester) async {
      // Given the app is running
      await theAppIsRunning(tester);

      // When I tap the password visibility toggle
      await iTapThePasswordVisibilityToggle(tester);

      // Then I should see the password as plain text
      await iShouldSeeThePasswordAsPlainText(tester);

      // And the analytics should track password visibility toggle event
      await theAnalyticsShouldTrackPasswordVisibilityToggleEvent(tester);
    });

    testWidgets('Toggle password visibility back to hidden', (tester) async {
      // Given the app is running
      await theAppIsRunning(tester);

      // And the password is visible
      await thePasswordIsVisible(tester);

      // When I tap the password visibility toggle
      await iTapThePasswordVisibilityToggle(tester);

      // Then I should see the password as dots
      await iShouldSeeThePasswordAsDots(tester);

      // And the analytics should track password visibility toggle event
      await theAnalyticsShouldTrackPasswordVisibilityToggleEvent(tester);
    });
  });
}
