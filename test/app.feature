Feature: App
    Scenario: Initial app launch
        Given the app is running
        Then I see {'Reference Test'} text
    Scenario: Empty answer
        Given the app is running
        When I tap {'Submit'} text
        Then I see {'Reference cannot be empty'} text
        And I see {'5'} text

    Scenario: Invalid Reference (is never correct)
        Given the app is running
        When I enter {'Revelation 9:99'} into {0} input field
        And I tap {'Submit'} text
        And I wait {3} seconds
        Then I don't see {'Reference cannot be empty'} text

    Scenario: Verse reference test progress tracking
        Given the app is running
        Then I see {'0%'} text
        When I enter {'Genesis 1:1'} into {0} input field
        And I tap {'Submit'} text
        And I wait {2} seconds
        Then I see {'100%'} text
        And I see {'1/1'} text
        When I enter {'John 3:17'} into {0} input field
        And I tap {'Submit'} text
        And I wait {2} seconds
        Then I see {'50%'} text
        And I see {'1/2'} text
