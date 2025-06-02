Feature: Hello World BDD Test

  Scenario: Basic app launch
    Given the app is running
    Then I see {'Hello'} text

  Scenario: Counter functionality
    Given the app is running
    When I tap {Icons.add} icon
    Then I see {'1'} text