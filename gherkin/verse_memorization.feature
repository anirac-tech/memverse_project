Feature: Verse Reference Practice
  As a user who has successfully logged in
  I want to practice identifying Bible verse references
  So that I can improve my scripture knowledge

  Background:
    Given I am logged into the Memverse app
    And I am on the main verse screen

  Scenario: Correct verse reference input
    Given I see a verse question "He is before all things, and in him all things hold together."
    When I enter the correct reference "Col 1:17"
    And I tap the submit button
    Then I should see green feedback indicating correct answer
    And I should see "Correct!" message
    And I should proceed to the next verse

  Scenario: Almost correct verse reference input
    Given I see a verse question "It is for freedom that Christ has set us free"
    When I enter an almost correct reference "Gal 5:2"
    And I tap the submit button
    Then I should see orange feedback indicating close answer
    And I should see "Not quite right" message with correct reference
    And I should proceed to the next verse

  Scenario: Incorrect verse reference input
    Given I see a verse question
    When I enter an incorrect reference with wrong book or chapter
    And I tap the submit button
    Then I should see orange feedback indicating incorrect answer
    And I should see the correct reference in the feedback
    And I should proceed to the next verse

  Scenario: Empty verse reference submission
    Given I see a verse question
    When I leave the reference field empty
    And I attempt to submit my answer
    Then I should see "Reference cannot be empty" error message
    And the form should not submit

  Scenario: Invalid reference format submission
    Given I see a verse question
    When I enter an invalid reference format
    And I attempt to submit my answer
    Then I should see "Invalid reference format" error message
    And the form should not submit

  Scenario: Verse progression and history tracking
    Given I am on the main verse screen
    When I answer the first verse correctly with "Col 1:17"
    And I wait for the next verse to load
    And I answer the second verse with "Gal 5:2"
    Then I should see "Past Questions" section
    And I should see my answer history
    And the history should show both attempted references with feedback

  Scenario: Happy path complete session
    Given I start a verse practice session
    When I correctly answer "Col 1:17" with green feedback
    And I answer "Gal 5:2" for "Gal 5:1" with orange feedback
    Then I should see both answers in my history
    And the app should continue cycling through available verses
