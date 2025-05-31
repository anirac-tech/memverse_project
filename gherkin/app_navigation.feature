Feature: App UI and Basic Navigation
  As a user of the Memverse app
  I want to navigate the basic app interface
  So that I can use the app effectively

  Background:
    Given I am logged into the Memverse app

  Scenario: Main app bar functionality
    Given I am on the main verse screen
    Then I should see "Memverse Reference Test" in the app bar
    And I should see a feedback button in the app bar
    And I should see a logout button in the app bar

  Scenario: Feedback button functionality
    Given I am on the main verse screen
    When I tap the feedback button
    Then I should see the feedback interface
    And I should be able to provide feedback about the app

  Scenario: Responsive layout on different screen sizes
    Given I am on the main verse screen
    When the screen width is less than 600 pixels
    Then the question section and history should be stacked vertically
    When the screen width is 600 pixels or more
    Then the question section and history should be side by side

  Scenario: Loading states
    Given the app is starting up
    When authentication status is being checked
    Then I should see a loading indicator
    When verses are being loaded
    Then I should see appropriate loading states

  Scenario: Error handling for authentication
    Given there is an authentication error
    When I try to access the app
    Then I should see "Error checking authentication status" message
    And I should be able to retry the authentication process
