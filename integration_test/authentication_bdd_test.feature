Feature: User Authentication BDD Tests

  Scenario: Successful login with valid credentials
    Given the app is running
    When I enter {'njwandroid@gmaiml.com'} into login username field
    And I enter {'fixmeplaceholder'} into login password field
    And I tap login button
    Then I see {'Memverse Reference Test'} text

  Scenario: Login validation with empty fields
    Given the app is running
    When I tap login button
    Then I see {'Please enter your username'} text
    And I see {'Please enter your password'} text

  Scenario: Password visibility toggle functionality
    Given the app is running
    When I enter {'testpassword'} into login password field
    Then I see {Icons.visibility_off} icon
    When I tap {Icons.visibility_off} icon
    Then I see {Icons.visibility} icon
    When I tap {Icons.visibility} icon
    Then I see {Icons.visibility_off} icon

  Scenario: Logout functionality
    Given the app is running
    And I am logged in as {'njwandroid@gmaiml.com'}
    When I tap {Icons.logout} icon
    Then I see login page
