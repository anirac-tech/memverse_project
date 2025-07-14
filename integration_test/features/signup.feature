Feature: User Signup
  As a new user
  I want to create an account
  So that I can use the Memverse app

  Background:
    Given I am on the signup page

  @happy-path
  Scenario: Successful signup with dummy credentials
    When I enter "dummynewuser@dummy.com" as email
    And I enter "Test User" as name
    And I enter "password123" as password
    And I tap the create account button
    Then I should see the welcome message
    And I should see my email displayed
    And I should be redirected to the main app

  @validation
  Scenario: Form validation for empty fields
    When I tap the create account button
    Then I should see "Please enter your email" error
    And I should see "Please enter your name" error
    And I should see "Please enter a password" error

  @validation
  Scenario: Form validation for invalid email
    When I enter "invalid-email" as email
    And I tap the create account button
    Then I should see "Please enter a valid email" error

  @validation
  Scenario: Form validation for short password
    When I enter "dummynewuser@dummy.com" as email
    And I enter "Test User" as name
    And I enter "short" as password
    And I tap the create account button
    Then I should see "Password must be at least 6 characters" error

  @error-case
  Scenario: Error message for non-dummy email
    When I enter "real@example.com" as email
    And I enter "Test User" as name
    And I enter "password123" as password
    And I tap the create account button
    Then I should see an orange error message