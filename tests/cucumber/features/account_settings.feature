Feature: Account information 
  As an user with an account
  I want to log in my account
  So I can view my personal and group information
  
  Scenario: Creating an account
    Given I have not logged in
    When I navigate to the "sign-in" page
    And I register an account
    Then I am logged in
    
