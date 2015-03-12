Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Filling out a form without logging in
    Given I have not logged in
    And I am on the "form" page
    Then I will see a message that requires me to log in
  
  Scenario: Filling in institution information
    Given I register an account
    And I am on the "form" page
    Then the information for the institution fields should be prepopulated

  Scenario: Submitting a ranavirus form
    Given I register an account
    And I am on the "form" page
    And I have logged in
    When I fill out the form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And the database should have a report linked to my account

  Scenario: Submitting without pathology report permission
    Given I have logged in
    And I am on the "form" page
    When I fill out the form
    When I choose "Permission Not Granted" for the pathologyReportPermission field
    Then the webpage should not display the pathologyReports.0.report field
    When I click submit
    Then the webpage should not display a validation error

  Scenario: Submitting a non-pdf publication
    Given I have logged in
    And I am on the "form" page
    When I fill out the form
    And I upload a non-pdf publication
    And I click submit
    Then the webpage should display a validation error

  Scenario: Submitting a publication without a reference
    Given I have logged in
    And I am on the "form" page
    When I fill out the form
    And I upload a pdf publication
    But I do not provide text for the reference field
    And I click submit
    Then the webpage should display a validation error
    When I fill out the publicationInfo.reference field with "the journal Nature"
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
