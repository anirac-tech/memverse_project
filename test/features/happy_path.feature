Feature: Happy Path User Journey
  As a Memverse user
  I want to login and answer verse references correctly and almost correctly
  So that I can see appropriate feedback for my memorization progress

  Background:
    Given the app is running with specific test verses

  Scenario: Complete happy path with correct and almost correct answers
    Given I am on the login screen
    When I enter username "njwandroid@gmaiml.com"
    And I enter password "fixmeplaceholder"
    And I tap the login button
    Then I should see "Memverse Reference Test"
    And I should see the first verse "He is before all things, and in him all things hold together."
    When I enter the reference "Col 1:17"
    And I tap the submit button
    Then I should see correct feedback with green styling
    And I should see "Correct!" message
    When the next verse loads
    Then I should see the second verse "It is for freedom that Christ has set us free"
    When I enter the reference "Gal 5:2"
    And I tap the submit button
    Then I should see almost correct feedback with orange styling
    And I should see "Not quite right" message
    And I should see the correct reference "Galatians 5:1" in the feedback

  Scenario: Login with specific credentials
    Given I am on the login screen
    When I enter username "njwandroid@gmaiml.com"
    And I enter password "fixmeplaceholder"
    And I tap the login button
    Then I should see "Memverse Reference Test"
    And I should not see any login errors

  Scenario: First verse correct answer feedback
    Given I am logged in and on the main screen
    And I see the verse "He is before all things, and in him all things hold together."
    When I enter the reference "Col 1:17"
    And I tap the submit button
    Then I should see correct feedback with green styling
    And I should see a green check icon
    And I should see "Correct!" message
    And the input field should have a green border

  Scenario: Second verse almost correct answer feedback
    Given I am logged in and on the main screen
    And I see the verse "It is for freedom that Christ has set us free"
    When I enter the reference "Gal 5:2"
    And I tap the submit button
    Then I should see almost correct feedback with orange styling
    And I should see an orange cancel icon
    And I should see "Not quite right" message with correct reference
    And the input field should have an orange border

  Scenario: Verse progression and history tracking
    Given I am logged in and on the main screen
    When I answer the first verse correctly with "Col 1:17"
    And I wait for the next verse to load
    And I answer the second verse with "Gal 5:2"
    Then I should see "Past Questions" section
    And I should see my answer history
    And the history should contain both attempted references
