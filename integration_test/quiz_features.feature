Feature: Quiz Features
  As a user
  I want to practice Bible verses through quizzes
  So that I can memorize scripture effectively

  Scenario: User completes a Reference Quiz successfully
    Given the app is running
    And I am logged in
    When I navigate to the Reference Quiz
    And I see a verse text displayed
    And I enter the correct reference
    And I submit my answer
    Then I should see positive feedback
    And my score should increase

  Scenario: User attempts Reference Quiz with incorrect answer
    Given the app is running
    And I am logged in
    When I navigate to the Reference Quiz
    And I see a verse text displayed
    And I enter an incorrect reference
    And I submit my answer
    Then I should see helpful feedback
    And I should be able to try again

  Scenario: User completes a Verse Text Quiz successfully
    Given the app is running
    And I am logged in
    When I navigate to the Verse Text Quiz
    And I see a verse reference displayed
    And I type the correct verse text
    And I submit my answer
    Then I should see positive feedback
    And my progress should be tracked

  Scenario: User navigates between quiz types
    Given the app is running
    And I am logged in
    When I am on the Reference Quiz
    And I navigate to settings
    And I return to quizzes
    Then I should see quiz options available
    And I can switch between quiz types

  Scenario: User switches between light and dark themes during quiz
    Given the app is running
    And I am logged in
    When I am practicing a quiz
    And I navigate to settings
    And I toggle the theme mode
    Then the app should display in the new theme
    And the quiz should remain accessible
    And text should be readable in both themes
