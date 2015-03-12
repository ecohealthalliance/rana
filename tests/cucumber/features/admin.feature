Feature: An admin role
  As an admin
  I want be able to delete reports
  so I can remove spam

  Scenario: Deleting a report
    Given I log in as admin
    And I am on the "table" page
    And there is a report in the database
    When I delete the report
    Then I should see the text "No reports"
