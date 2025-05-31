Feature: Verse Reference Practice BDD Tests

  Background:
    Given the app is running
    And I am logged in as {'njwandroid@gmaiml.com'}

  Scenario: Correct verse reference provides green feedback
    Given I see {'He is before all things, and in him all things hold together.'} text
    When I enter {'Col 1:17'} into reference input field
    And I tap submit button
    Then I see {'Correct!'} text

  Scenario: Almost correct verse reference provides orange feedback
    Given I see {'It is for freedom that Christ has set us free'} text
    When I enter {'Gal 5:2'} into reference input field
    And I tap submit button
    Then I see {'Not quite right'} text
    And I see {'Galatians 5:1'} text

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

  Scenario: Happy path complete flow
    When I enter {'Col 1:17'} into reference input field
    And I tap submit button
    Then I see {'Correct!'} text
    When I enter {'Gal 5:2'} into reference input field
    And I tap submit button
    Then I see {'Not quite right'} text
    And I see {'Prior Questions'} text
