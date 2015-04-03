Feature: A form for setting up a ranavirus study
  As a user
  I want to set up a ranavirus study
  So I can add reports individually or import them

  Scenario: Filling in institution information
    Given I register an account
    And I have logged in
    And I am on the "study" page
    Then the information for the institution fields should be prepopulated

  Scenario: Submitting a non-pdf publication
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I upload a non-pdf publication
    And I click submit
    Then the webpage should display a validation error

  Scenario: Submitting a publication without a reference
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I upload a pdf publication
    But I do not provide text for the reference field
    And I click submit
    Then the webpage should display a validation error
    When I fill out the publicationInfo.reference field with "the journal Nature"
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast

  Scenario: Importing a CSV file
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I upload the CSV file rana_import_one.csv
    Then the preview table should contain the values for rana_import_one.csv
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And the database should have 1 reports linked to my account
    Then I navigate to the "table" page
    And I click on the edit button
    Then the form should contain the values for rana_import_one.csv

  Scenario: Importing a complete CSV file
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I upload the CSV file rana_import_complete.csv
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And the database should have 1 reports linked to my account
    Then I navigate to the "table" page
    And I click on the edit button
    Then the form should contain the values for rana_import_complete.csv
