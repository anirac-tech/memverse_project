Feature: Password Visibility Toggle
  As a user
  I want to toggle password visibility
  So that I can verify what I'm typing

  Scenario: Toggle password visibility
    Given the app is running
    When I tap the password visibility toggle
    Then I should see the password as plain text
    And the analytics should track password visibility toggle event

  Scenario: Toggle password visibility back to hidden
    Given the app is running
    And the password is visible
    When I tap the password visibility toggle
    Then I should see the password as dots
    And the analytics should track password visibility toggle event