Feature: An admin role
  As an admin
  I want be able to delete reports
  so I can remove spam

  Scenario: Deleting a report
    Given I am on the "table" page
    And I have logged in as admin
    And I am logged in
    And there is a report in the database
    When I delete the report
    Then I should see the text "No reports"

  Scenario: Deleting someone else's report
    Given I am on the "table" page
    And I have logged in
    And there is a report created by someone else in the database
    Then there should be no delete button for the report by someone else
