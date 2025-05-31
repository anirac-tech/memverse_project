Feature: App UI and Navigation BDD Tests
  As a developer
  I want to test app UI and navigation functionality
  So that I can ensure the interface works correctly

  Background:
    Given the app is running
    And I am logged in as "njwandroid@gmaiml.com"

  Scenario: Main app bar elements are present
    Given I am on the main verse screen
    Then I should see "Memverse Reference Test" in the app bar
    And I should see the feedback button
    And I should see the logout button

  Scenario: Feedback button functionality
    Given I am on the main verse screen
    When I tap the feedback button
    Then the feedback interface should be displayed
    And I should be able to interact with feedback options

  Scenario: Responsive layout behavior
    Given I am on the main verse screen
    When the app is in a narrow layout
    Then the question section should be above the history section
    When the app is in a wide layout
    Then the question section should be beside the history section

  Scenario: Loading states display correctly
    Given the app is starting up
    When authentication is being verified
    Then I should see a loading indicator
    When the app encounters an error
    Then I should see appropriate error messages

  Scenario: App state persistence during navigation
    Given I am on the main verse screen
    And I have answered some verses
    When I navigate within the app
    Then my previous answers should remain in the history
    And the current verse state should be preserved