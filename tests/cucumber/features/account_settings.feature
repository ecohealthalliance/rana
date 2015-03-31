Feature: Account information
  As an user with an account
  I want to log in my account
  So I can view my personal and group information

  Scenario: Creating an account
    Given I have not logged in
    When I navigate to the "sign-in" page
    And I register an account
    Then I am logged in
    
  Scenario: Editing profile
    Given I have logged in
    When I navigate to the "profile" page
    Then the name field should have the value "Test User"
    When I fill out the name field with "New Name"
    And I click submit
    Then the webpage should not display a validation error
    Then I should see the text "New Name\nEdit Your Profile"
    And the name field should have the value "New Name"
