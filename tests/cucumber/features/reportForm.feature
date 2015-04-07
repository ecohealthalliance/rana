Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Filling out a form without logging in
    Given I have not logged in
    And I am on the "report" page
    Then I will see a message that requires me to log in

  Scenario: Filling in institution information
    Given I register an account
    And I have logged in
    And I am on the "report" page
    And I select the #1 study
    Then the information for the institution fields should be prepopulated

  Scenario: Submitting a ranavirus form
    Given I register an account
    And I am on the "report" page
    And I select the #1 study
    And I have logged in
    When I fill out the form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And the database should have a report linked to my account

  Scenario: Getting report defaults from a study
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form with some default report values
    And I click submit
    And I navigate to the "report" page
    And I select the #2 study
    Then the information from the study should be prepopulated
