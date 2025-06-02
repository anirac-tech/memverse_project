import 'package:flutter_test/flutter_test.dart';

import 'step/feedback_validation.dart';
// Step definitions
import 'step/the_app_is_running_with_specific_test_verses.dart';
import 'step/user_interactions.dart';

void main() {
  group('Happy Path User Journey BDD Tests', () {
    testWidgets('Complete happy path with correct and almost correct answers', (tester) async {
      await theAppIsRunningWithSpecificTestVerses(tester);

      // Verify login screen elements
      expect(find.text('Welcome to Memverse'), findsOneWidget);

      // Login with credentials
      await iEnterUsername(tester, 'njwandroid@gmaiml.com');
      await iEnterPassword(tester, 'fixmeplaceholder');
      await iTapTheLoginButton(tester);

      // Verify main screen
      expect(find.textContaining('Reference Test'), findsOneWidget);
      expect(
        find.text('He is before all things, and in him all things hold together.'),
        findsOneWidget,
      );

      // First verse - correct answer
      await iEnterTheReference(tester, 'Col 1:17');
      await iTapTheSubmitButton(tester);

      // Verify correct feedback
      await iShouldSeeCorrectFeedbackWithGreenStyling(tester);
      expect(find.textContaining('Correct'), findsOneWidget);

      // Wait for next verse
      await iWaitForTheNextVerseToLoad(tester);

      // Verify second verse loaded
      expect(find.textContaining('It is for freedom that Christ has set us free'), findsOneWidget);

      // Second verse - almost correct answer
      await iEnterTheReference(tester, 'Gal 5:2');
      await iTapTheSubmitButton(tester);

      // Verify almost correct feedback
      await iShouldSeeAlmostCorrectFeedbackWithOrangeStyling(tester);
      await iShouldSeeNotQuiteRightMessageWithCorrectReference(tester);

      // Verify history section
      expect(find.textContaining('Past Questions'), findsOneWidget);
    });

    testWidgets('Login with specific credentials', (tester) async {
      await theAppIsRunningWithSpecificTestVerses(tester);

      await iEnterUsername(tester, 'njwandroid@gmaiml.com');
      await iEnterPassword(tester, 'fixmeplaceholder');
      await iTapTheLoginButton(tester);

      expect(find.textContaining('Reference Test'), findsOneWidget);
      await iShouldNotSeeAnyLoginErrors(tester);
    });

    testWidgets('First verse correct answer feedback', (tester) async {
      await theAppIsRunningWithSpecificTestVerses(tester);

      // Skip login for this test - assume we're logged in
      expect(
        find.text('He is before all things, and in him all things hold together.'),
        findsOneWidget,
      );

      await iEnterTheReference(tester, 'Col 1:17');
      await iTapTheSubmitButton(tester);

      await iShouldSeeCorrectFeedbackWithGreenStyling(tester);
      await iShouldSeeAGreenCheckIcon(tester);
      expect(find.textContaining('Correct'), findsOneWidget);
      await theInputFieldShouldHaveAGreenBorder(tester);
    });

    testWidgets('Second verse almost correct answer feedback', (tester) async {
      await theAppIsRunningWithSpecificTestVerses(tester);

      // Navigate to second verse (simulate progression)
      await iEnterTheReference(tester, 'Col 1:17');
      await iTapTheSubmitButton(tester);
      await iWaitForTheNextVerseToLoad(tester);

      expect(find.textContaining('It is for freedom that Christ has set us free'), findsOneWidget);

      await iEnterTheReference(tester, 'Gal 5:2');
      await iTapTheSubmitButton(tester);

      await iShouldSeeAlmostCorrectFeedbackWithOrangeStyling(tester);
      await iShouldSeeAnOrangeCancelIcon(tester);
      await iShouldSeeNotQuiteRightMessageWithCorrectReference(tester);
      await theInputFieldShouldHaveAnOrangeBorder(tester);
    });

    testWidgets('Verse progression and history tracking', (tester) async {
      await theAppIsRunningWithSpecificTestVerses(tester);

      // Answer first verse correctly
      await iAnswerTheFirstVerseCorrectlyWith(tester, 'Col 1:17');
      await iWaitForTheNextVerseToLoad(tester);

      // Answer second verse with almost correct
      await iAnswerTheSecondVerseWith(tester, 'Gal 5:2');

      // Verify history
      expect(find.textContaining('Past Questions'), findsOneWidget);
      // Should contain both attempted references in history
      expect(find.textContaining('Col 1:17'), findsOneWidget);
      expect(find.textContaining('Gal 5:2'), findsOneWidget);
    });
  });
}
