Feature: Account information
  As an user with an account
  I want to log in my account
  So I can view my personal and group information

  Scenario: Creating an account
    Given I have not logged in
    When I navigate to the "sign-in" page
    And I register an account
    Then I am logged in

Scenario: Updating a profile
    Given I have logged in
    And I am on the "study" page
    And I click on the admin settings button
    And I click on the profile button
    And I fill out the profile form differently
    And I click submit
    Then the form should contain the different profile values I entered
