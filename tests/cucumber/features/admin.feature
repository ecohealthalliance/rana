Feature: An admin role
  As an admin
  I want be able to delete reports
  so I can remove spam

  Scenario: Admin deleting a report
    Given I am on the "table" page
    And I have logged in as admin
    And there is a report in the database
    When I delete the report
    Then I should see the text "No reports"

  Scenario: Non-admin trying to delete someone else's report
    Given I am on the "table" page
    And I have logged in
    And there is a report created by someone else in the database
    Then there should be no delete button for the report by someone else

  Scenario: Admin deleting a study
    Given I am on the "studies" page
    And I have logged in as admin
    And there is a study in the database
    When I delete the study
    Then I should see the text "No studies"

  Scenario: Non-admin trying to delete someone else's study
    Given I am on the "studies" page
    And I have logged in
    And there is a study created by someone else in the database
    Then there should be no delete button for the study by someone else
