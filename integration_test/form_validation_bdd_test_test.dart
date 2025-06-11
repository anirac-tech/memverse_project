import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'step/form_validation_steps.dart';
import 'step/i_see_text.dart';
import 'step/the_app_is_running.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Form Validation BDD Tests', () {
    testWidgets('Empty username validation', (tester) async {
      // Given the app is running
      await theAppIsRunning(tester);

      // When I tap the login button without entering a username
      await iTapTheLoginButtonWithoutEnteringAUsername(tester);

      // Then I should see "Please enter your username"
      await iSeeText(tester, 'Please enter your username');

      // And the analytics should track empty username validation event
      await theAnalyticsShouldTrackEmptyUsernameValidationEvent(tester);
    });

    testWidgets('Empty password validation', (tester) async {
      // Given the app is running
      await theAppIsRunning(tester);

      // And I have entered a username
      await iHaveEnteredAUsername(tester);

      // When I tap the login button without entering a password
      await iTapTheLoginButtonWithoutEnteringAPassword(tester);

      // Then I should see "Please enter your password"
      await iSeeText(tester, 'Please enter your password');

      // And the analytics should track empty password validation event
      await theAnalyticsShouldTrackEmptyPasswordValidationEvent(tester);
    });

    testWidgets('Both fields empty validation', (tester) async {
      // Given the app is running
      await theAppIsRunning(tester);

      // When I tap the login button without entering any credentials
      await iTapTheLoginButtonWithoutEnteringAnyCredentials(tester);

      // Then I should see "Please enter your username"
      await iSeeText(tester, 'Please enter your username');

      // And I should see "Please enter your password"
      await iSeeText(tester, 'Please enter your password');

      // And the analytics should track both validation events
      await theAnalyticsShouldTrackBothValidationEvents(tester);
    });
  });
}
