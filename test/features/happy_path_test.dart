// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running_with_specific_test_verses.dart';
import './step/i_am_on_the_login_screen.dart';
import './step/i_enter_username_njwandroidgmaimlcom.dart';
import './step/i_enter_password_fixmeplaceholder.dart';
import './step/i_tap_the_login_button.dart';
import './step/i_should_see_memverse_reference_test.dart';
import './step/i_should_see_the_first_verse_he_is_before_all_things_and_in_him_all_things_hold_together.dart';
import './step/i_enter_the_reference_col117.dart';
import './step/i_tap_the_submit_button.dart';
import './step/i_should_see_correct_feedback_with_green_styling.dart';
import './step/i_should_see_correct_message.dart';
import './step/the_next_verse_loads.dart';
import './step/i_should_see_the_second_verse_it_is_for_freedom_that_christ_has_set_us_free.dart';
import './step/i_enter_the_reference_gal52.dart';
import './step/i_should_see_almost_correct_feedback_with_orange_styling.dart';
import './step/i_should_see_not_quite_right_message.dart';
import './step/i_should_see_the_correct_reference_galatians51_in_the_feedback.dart';
import './step/i_should_not_see_any_login_errors.dart';
import './step/i_am_logged_in_and_on_the_main_screen.dart';
import './step/i_see_the_verse_he_is_before_all_things_and_in_him_all_things_hold_together.dart';
import './step/i_should_see_a_green_check_icon.dart';
import './step/the_input_field_should_have_a_green_border.dart';
import './step/i_see_the_verse_it_is_for_freedom_that_christ_has_set_us_free.dart';
import './step/i_should_see_an_orange_cancel_icon.dart';
import './step/i_should_see_not_quite_right_message_with_correct_reference.dart';
import './step/the_input_field_should_have_an_orange_border.dart';
import './step/i_answer_the_first_verse_correctly_with_col117.dart';
import './step/i_wait_for_the_next_verse_to_load.dart';
import './step/i_answer_the_second_verse_with_gal52.dart';
import './step/i_should_see_past_questions_section.dart';
import './step/i_should_see_my_answer_history.dart';
import './step/the_history_should_contain_both_attempted_references.dart';

void main() {
  group('''Happy Path User Journey''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await theAppIsRunningWithSpecificTestVerses(tester);
    }

    testWidgets('''Complete happy path with correct and almost correct answers''', (tester) async {
      await bddSetUp(tester);
      await iAmOnTheLoginScreen(tester);
      await iEnterUsernameNjwandroidgmaimlcom(tester);
      await iEnterPasswordFixmeplaceholder(tester);
      await iTapTheLoginButton(tester);
      await iShouldSeeMemverseReferenceTest(tester);
      await iShouldSeeTheFirstVerseHeIsBeforeAllThingsAndInHimAllThingsHoldTogether(tester);
      await iEnterTheReferenceCol117(tester);
      await iTapTheSubmitButton(tester);
      await iShouldSeeCorrectFeedbackWithGreenStyling(tester);
      await iShouldSeeCorrectMessage(tester);
      await theNextVerseLoads(tester);
      await iShouldSeeTheSecondVerseItIsForFreedomThatChristHasSetUsFree(tester);
      await iEnterTheReferenceGal52(tester);
      await iTapTheSubmitButton(tester);
      await iShouldSeeAlmostCorrectFeedbackWithOrangeStyling(tester);
      await iShouldSeeNotQuiteRightMessage(tester);
      await iShouldSeeTheCorrectReferenceGalatians51InTheFeedback(tester);
    });
    testWidgets('''Login with specific credentials''', (tester) async {
      await bddSetUp(tester);
      await iAmOnTheLoginScreen(tester);
      await iEnterUsernameNjwandroidgmaimlcom(tester);
      await iEnterPasswordFixmeplaceholder(tester);
      await iTapTheLoginButton(tester);
      await iShouldSeeMemverseReferenceTest(tester);
      await iShouldNotSeeAnyLoginErrors(tester);
    });
    testWidgets('''First verse correct answer feedback''', (tester) async {
      await bddSetUp(tester);
      await iAmLoggedInAndOnTheMainScreen(tester);
      await iSeeTheVerseHeIsBeforeAllThingsAndInHimAllThingsHoldTogether(tester);
      await iEnterTheReferenceCol117(tester);
      await iTapTheSubmitButton(tester);
      await iShouldSeeCorrectFeedbackWithGreenStyling(tester);
      await iShouldSeeAGreenCheckIcon(tester);
      await iShouldSeeCorrectMessage(tester);
      await theInputFieldShouldHaveAGreenBorder(tester);
    });
    testWidgets('''Second verse almost correct answer feedback''', (tester) async {
      await bddSetUp(tester);
      await iAmLoggedInAndOnTheMainScreen(tester);
      await iSeeTheVerseItIsForFreedomThatChristHasSetUsFree(tester);
      await iEnterTheReferenceGal52(tester);
      await iTapTheSubmitButton(tester);
      await iShouldSeeAlmostCorrectFeedbackWithOrangeStyling(tester);
      await iShouldSeeAnOrangeCancelIcon(tester);
      await iShouldSeeNotQuiteRightMessageWithCorrectReference(tester);
      await theInputFieldShouldHaveAnOrangeBorder(tester);
    });
    testWidgets('''Verse progression and history tracking''', (tester) async {
      await bddSetUp(tester);
      await iAmLoggedInAndOnTheMainScreen(tester);
      await iAnswerTheFirstVerseCorrectlyWithCol117(tester);
      await iWaitForTheNextVerseToLoad(tester);
      await iAnswerTheSecondVerseWithGal52(tester);
      await iShouldSeePastQuestionsSection(tester);
      await iShouldSeeMyAnswerHistory(tester);
      await theHistoryShouldContainBothAttemptedReferences(tester);
    });
  });
}
