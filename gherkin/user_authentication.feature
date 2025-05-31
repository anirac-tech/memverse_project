Feature: User Authentication
  As a user of the Memverse app
  I want to securely log into my account
  So that I can access verse memorization practice

  Background:
    Given the Memverse app is launched
    And I am on the login screen

  Scenario: Successful login with valid credentials
    Given I have valid login credentials
    When I enter my username "njwandroid@gmaiml.com"
    And I enter my password "fixmeplaceholder"
    And I tap the "Login" button
    Then I should be redirected to the main verse screen
    And I should see "Memverse Reference Test"

  Scenario: Failed login with invalid credentials
    Given I am on the login screen
    When I enter an invalid username "invalid@email.com"
    And I enter any password
    And I tap the "Login" button
    Then I should see an error message
    And I should remain on the login screen

  Scenario: Login with empty fields
    Given I am on the login screen
    When I leave both username and password fields empty
    And I tap the "Login" button
    Then I should see validation error messages
    And the form should not submit

  Scenario: Password visibility toggle
    Given I am on the login screen
    When I enter a password
    Then the password should be hidden by default
    When I tap the password visibility toggle
    Then the password should become visible
    When I tap the password visibility toggle again
    Then the password should be hidden again

  Scenario: Logout functionality
    Given I am logged into the app
    When I tap the logout button in the app bar
    Then I should be logged out
    And I should return to the login screen
