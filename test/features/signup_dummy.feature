Feature: Dummy User Signup
  As a new user
  I want to sign up with a dummy account
  So that I can test the signup flow without internet connection

  Background:
    Given the app is running with fake user repository

  Scenario: Successful dummy signup
    Given I am on the login screen
    When I tap "Sign Up"
    Then I should see the signup form
    When I enter "dummynewuser@dummy.com" in the email field
    And I enter "dummyuser" in the username field
    And I enter "test123" in the password field
    And I tap "Create Account"
    Then I should see "Welcome to Memverse!"
    And I should see "Account created successfully"
    And I should see "dummynewuser@dummy.com"

  Scenario: Invalid email signup
    Given I am on the login screen
    When I tap "Sign Up"
    Then I should see the signup form
    When I enter "invalid@test.com" in the email field
    And I enter "testuser" in the username field
    And I enter "test123" in the password field
    And I tap "Create Account"
    Then I should see "User creation failed"