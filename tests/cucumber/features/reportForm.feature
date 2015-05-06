Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Filling out a form without logging in
    Given I have not logged in
    And I am on the "study/fakeid/report" page
    Then I will see a message that requires me to log in

  Scenario: Filling in institution information
    Given I register an account
    And I have logged in
    And I am on the "study/fakeid/report" page
    Then the information for the institution fields should be prepopulated

  Scenario: Submitting a ranavirus form
    Given I register an account
    And I am on the "study/fakeid/report" page
    And I have logged in
    When I fill out the form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And the database should have 1 reports linked to my account
    And the data I filled out the form with should be in the database

  Scenario: Getting report defaults from a study
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form with some default report values
    And I click submit
    And I navigate to the "studies" page
    And I click the link for the the study called "Study"
    Then the information from the study should be prepopulated

  Scenario: Uploading an image
    Given I have logged in
    And I am on the "study/fakeid/report" page
    When I upload an image
    And I click submit
    And I click the "Edit Report" button
    Then I should see an image preview

  Scenario: Redirecting after report submission
    Given I have logged in
    And I am on the "study/fakeid/report" page
    And I have logged in
    When I fill out the form
    And I click submit
    And I navigate to the "table" page
    And I click on the edit button
    And I click submit
    Then I should be on the "table" page

  Scenario: Redirecting after new report submission
    Given I have logged in
    And I am on the "study/fakeid" page
    And I click the Add a report button
    And I click submit
    Then I should be on the "study/fakeid" page
