Feature: Verse Reference Practice BDD Tests

  Background:
    Given the app is running
    And I am logged in as test user

  Scenario: Correct verse reference provides feedback
    Given I see verse text
    When I enter {'Col 1:17'} into reference input field
    And I tap submit button
    Then I should see input field color {Colors.green}
    And I see {'Correct!'} text

  Scenario: Almost correct verse reference provides feedback
    Given I see verse text
    When I enter {'Gal 5:2'} into reference input field
    And I tap submit button
    Then I should see input field color {Colors.orange}
    And I see {'Not quite right'} text

  Scenario: Empty reference validation
    When I tap submit button
    Then I see {'Reference cannot be empty'} text

  Scenario: Invalid reference format validation
    When I enter {'invalid format'} into reference input field
    And I tap submit button
    Then I see {'Invalid reference format'} text

  Scenario: Answer history tracking
    When I enter {'Col 1:17'} into reference input field
    And I tap submit button
    And I enter {'Gal 5:2'} into reference input field
    And I tap submit button
    Then I see {'Prior Questions'} text
