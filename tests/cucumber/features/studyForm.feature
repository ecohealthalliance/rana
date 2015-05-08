Feature: A form for setting up a ranavirus study
  As a user
  I want to set up a ranavirus study
  So I can add reports individually or import them

  Scenario: Importing a complete CSV file
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I upload the CSV file rana_import_complete.csv
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And the database should have 1 reports linked to my account
    When I dismiss the toast
    And I navigate to the "table" page
    And I click on the edit button
    Then the form should contain the values for rana_import_complete.csv

  Scenario: Updating a study
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    When I dismiss the toast
    And I navigate to the "studies" page
    And I click the link for the the study called "Study"
    And I fill out the study form differently
    And I click submit again
    And I click the link for the the study called "Study"
    Then the form should contain the different values I entered

  Scenario: Removing a study
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    When I navigate to the "studies" page
    And I click the "Remove" button
    And I type "delete" into the prompt
    And I accept the prompt
    Then I should not see the text "No Studies Found"
    When I click the "Remove" button
    And I type "delete" into the prompt
    And I accept the prompt
    Then I should see the text "No Studies Found"

  Scenario: Trying to re-use a study name
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    When I dismiss the toast
    And I navigate to the "study" page
    And I fill out the study form
    And I click submit again
    Then the webpage should display a validation error

  Scenario: Redirecting after editing a study
    Given I have logged in
    And I am on the "studies" page
    And I click on the edit button
    And I click submit
    Then I should be on the "studies" page
