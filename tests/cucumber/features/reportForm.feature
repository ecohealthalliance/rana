Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  @report
  Scenario: Filling out a form without logging in
    Given I have not logged in
    And I am on the "study/fakeid/report" page
    Then I will see a message that requires me to log in

  @report
  Scenario: Filling in institution information
    Given I register an account
    And I have logged in
    And I am on the "study/fakeid/report" page
    Then the information for the institution fields should be prepopulated

  @report
  Scenario: Submitting a ranavirus form
    Given I register an account
    And I am on the "study/fakeid/report" page
    And I have logged in
    When I fill out the form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And I should see the report form
    And the database should have 1 reports linked to my account
    And the data I filled out the form with should be in the database

  @report
  Scenario: Getting report defaults from a study
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form with some default report values
    And I click submit
    And I navigate to the "studies" page
    And I click the add-report button for the study called "Study"
    Then the information from the study should be prepopulated

  @report
  Scenario: Uploading an image
    Given I have logged in
    And I am on the "study/fakeid/report" page
    When I upload an image
    And I click submit
    And I click the "Edit Report" button
    Then I should see an image preview

  @report
  Scenario: Obfuscated reports show only contact information and country
    Given I have logged in
    When I navigate to the "study/fakeid/report" page
    And I fill out a report with obfuscated permissions
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    When I log out
    And I register an account
    And I navigate to the "table" page
    And I click on the view button
    Then the webpage should not display the speciesGenus field
    And the contact.name field should have the value "Fake Name"

  @report
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

  @report
  Scenario: Redirecting after new report submission
    Given I have logged in
    And I am on the "study/fakeid" page
    And I click the Add a report button
    And I click submit
    Then I should be on the "study/fakeid" page

  @report
  Scenario: Redirecting after new report submission
    Given I have logged in
    And I am on the "study/fakeid" page
    And I click the Add a report button
    And I click submit
    Then I should be on the "study/fakeid" page

  @report
  Scenario: Reviews don't appear on report insert forms
    Given I have logged in
    And I am on the "study/fakeid" page
    And I click the Add a report button
    Then I should not see the review panel header

  @report
  Scenario: Reviews appear on reports user has added
    Given I have logged in
    And I am on the "study/fakeid" page
    And I click the Add a report button
    When I fill out the form
    And I click submit
    And I click the "Edit Report" button
    Then I should see the review panel header
