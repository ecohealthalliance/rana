Feature: The ability to import CSV records into an existing study
  As a user
  I want to import CSV records into an existing study

  @import
  Scenario: Importing a complete CSV file
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I click submit
    And I navigate to the "studies" page
    And I click the edit button for the study called "Study"
    And I click the "Import CSV Reports" button
    And I upload the CSV file rana_import_complete.csv
    And I click the "Import reports" button
    Then the webpage should not display a validation error
    And I should see a "Added 1 report(s) to study Study" toast
    And the database should have 1 reports linked to my account
    When I dismiss the toast
    And I navigate to the "table" page
    And I click on the edit button
    Then the form should contain the values for rana_import_complete.csv

  @import
  Scenario: Importing an invalid CSV file
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I click submit
    And I navigate to the "studies" page
    And I click the edit button for the study called "Study"
    And I click the "Import CSV Reports" button
    When I upload the CSV file rana_invalid.csv
    Then I should see the text "Error: Binomial species names are required"

  @import
  Scenario: Importing and removing a CSV file
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I click submit
    And I navigate to the "studies" page
    And I click the edit button for the study called "Study"
    And I click the "Import CSV Reports" button
    And I upload the CSV file rana_import_complete.csv
    Then I should see 1 report in the table
    And I should see the text "Unused fields in your data"
    When I remove the CSV file
    Then I should not see the text "File: rana_import_complete.csv"
