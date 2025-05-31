Feature: App UI and Navigation BDD Tests

  Background:
    Given the app is running
    And I am logged in as {'njwandroid@gmaiml.com'}

  Scenario: Main app bar elements are present
    Then I see {'Memverse Reference Test'} text
    And I see {Icons.feedback_outlined} icon
    And I see {Icons.logout} icon

  Scenario: Feedback button functionality
    When I tap {Icons.feedback_outlined} icon
    Then I see feedback interface

  Scenario: Loading states display correctly
    Given the app is starting up
    Then I see loading indicator

  Scenario: UI text elements are visible
    Then I see {'Reference:'} text
    And I see {'Submit'} text
    And I see {'He is before all things'} text
