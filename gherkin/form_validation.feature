Feature: Form Validation
  As a user
  I want to see validation errors for empty fields
  So that I know what information is required

  Scenario: Empty username validation
    Given the app is running
    When I tap the login button without entering a username
    Then I should see "Please enter your username"
    And the analytics should track empty username validation event

  Scenario: Empty password validation
    Given the app is running
    And I have entered a username
    When I tap the login button without entering a password
    Then I should see "Please enter your password"
    And the analytics should track empty password validation event

  Scenario: Both fields empty validation
    Given the app is running
    When I tap the login button without entering any credentials
    Then I should see "Please enter your username"
    And I should see "Please enter your password"
    And the analytics should track both validation events