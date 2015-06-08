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

  Scenario: Filtering reports by population type
    Given I am on the "table" page
    And there is a report with "populationType" "zoological" in the database
    And there is a report with "populationType" "wild" in the database
    When I add a filter where "populationType" is "wild"
    Then I should see 1 report in the table
    When I remove the filters
    Then I should see 2 reports in the table
    When I add a filter where "populationType" is "production"
    Then I should see 0 reports in the table

  Scenario: Adding the same filter twice
    Given I am on the "table" page
    And there is a report with "populationType" "zoological" in the database
    And there is a report with "populationType" "wild" in the database
    When I add a filter where "populationType" is "wild"
    And I add a second filter where "populationType" is "production"
    Then I should see 0 reports in the table