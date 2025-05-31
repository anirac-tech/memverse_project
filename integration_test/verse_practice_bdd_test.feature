Feature: Verse Reference Practice BDD Tests
  As a developer
  I want to test verse reference practice functionality
  So that I can ensure verse practice works correctly

  Background:
    Given the app is running with test verses
    And I am logged in as "njwandroid@gmaiml.com"

  Scenario: Correct verse reference provides green feedback
    Given I am on the main verse screen
    And I see the verse "He is before all things, and in him all things hold together."
    When I enter reference "Col 1:17"
    And I tap the submit button
    Then I should see green feedback styling
    And I should see "Correct!" message
    And the next verse should load

  Scenario: Almost correct verse reference provides orange feedback
    Given I am on the main verse screen
    And I see the verse "It is for freedom that Christ has set us free"
    When I enter reference "Gal 5:2"
    And I tap the submit button
    Then I should see orange feedback styling
    And I should see "Not quite right" message
    And I should see the correct reference "Galatians 5:1"
    And the next verse should load

  Scenario: Empty reference validation
    Given I am on the main verse screen
    When I leave the reference field empty
    And I tap the submit button
    Then I should see "Reference cannot be empty" snackbar
    And the form should not progress

  Scenario: Invalid reference format validation
    Given I am on the main verse screen
    When I enter invalid reference "invalid format"
    And I tap the submit button
    Then I should see "Invalid reference format" snackbar
    And the form should not progress

  Scenario: Answer history tracking
    Given I am on the main verse screen
    When I answer "Col 1:17" correctly
    And I answer "Gal 5:2" for the next verse
    Then I should see "Past Questions" section
    And I should see both answers in the history
    And the history should show correct feedback indicators

  Scenario: Happy path complete flow
    Given I am on the main verse screen
    When I correctly answer "Col 1:17" with green feedback
    And I answer "Gal 5:2" for "Gal 5:1" with orange feedback
    Then both answers should appear in my history
    And I should be able to continue with more verses