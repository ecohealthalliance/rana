Feature: A table with data from all the ranavirus reports
  As a user
  I want to see ranavirus reports in a table
  so I can view and edit them.

  Scenario: Table page with no results
    Given I am on the "table" page
    And there are no reports in the database
    Then I should see the text "No reports"

  Scenario: Toggling columns
    Given I am on the "table" page
    And there is a report in the database
    When I click the "Columns" button
    Then I should not see a checkbox for the edit column
