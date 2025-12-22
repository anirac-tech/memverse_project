Feature: Theme Toggle
  As a user
  I want to toggle between light and dark themes
  So that I can use the app comfortably in different lighting conditions

  Scenario: User toggles from light to dark theme
    Given the app is running in light mode
    When I navigate to settings
    And I toggle the dark mode switch
    Then the app should display in dark theme
    And all text should remain readable

  Scenario: User toggles from dark to light theme
    Given the app is running in dark mode
    When I navigate to settings
    And I toggle the dark mode switch
    Then the app should display in light theme
    And all UI elements should be visible

  Scenario: Theme preference persists across navigation
    Given the app is running
    When I navigate to settings
    And I toggle to dark mode
    And I navigate to quiz screens
    And I return to settings
    Then the dark mode should still be enabled

  Scenario: Theme applies to all screens consistently
    Given the app is running
    When I toggle to dark mode in settings
    And I navigate to reference quiz
    Then the reference quiz should use dark theme
    When I navigate to verse text quiz
    Then the verse text quiz should use dark theme
    When I navigate to home
    Then the home screen should use dark theme
