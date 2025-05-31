Feature: User Authentication BDD Tests
  As a developer
  I want to test user authentication functionality
  So that I can ensure login and logout work correctly

  Background:
    Given the app is running

  Scenario: Successful login with valid credentials
    Given I am on the login screen
    When I enter username "njwandroid@gmaiml.com"
    And I enter password "fixmeplaceholder"
    And I tap the login button
    Then I should see the main verse screen
    And I should see "Memverse Reference Test"

  Scenario: Login validation with empty fields
    Given I am on the login screen
    When I leave username field empty
    And I leave password field empty
    And I tap the login button
    Then I should see username validation error
    And I should see password validation error

  Scenario: Password visibility toggle functionality
    Given I am on the login screen
    When I enter password "testpassword"
    Then the password should be obscured
    When I tap the password visibility icon
    Then the password should be visible
    When I tap the password visibility icon again
    Then the password should be obscured

  Scenario: Logout functionality
    Given I am logged in as "njwandroid@gmaiml.com"
    When I tap the logout button
    Then I should return to the login screen
    And I should not be authenticated