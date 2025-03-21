Feature: App
    Scenario: Initial app launch
        Given the app is running
        Then I see {'Reference Test'} text
    Scenario: Empty answer
        Given the app is running
        When I tap {'Submit'} text
        Then I see {'Reference cannot be empty'} text
        And I see {'5'} text