Feature: A map that plots ranavirus reports
  As a user
  I want to see ranavirus reports plotted on a map
  So I can observe geographic ranavirus trends

  Scenario: Opening a report popup
    Given I am on the "map" page
    And there is a report with a geopoint in the database
    When I click on a report location marker
    Then I should see a popup with information from the report

  Scenario: Filtering reports by genus
    Given I am on the "map" page
    And there is a report with "genus" "X" in the database
    And there is a report with "genus" "Y" in the database
    When I add a filter for the property "genus" and value "X"
    Then I should see 1 report
    When I remove the filters
    Then I should see 2 reports
    When I add a filter for the property "genus" and value "Z"
    Then I should see 0 reports
