Feature: A map that plots ranavirus reports
  As a user
  I want to see ranavirus reports plotted on a map
  So I can observe geographic ranavirus trends

  Scenario: Opening a report popup
    Given I am on the "map" page
    And there is a report with a geopoint in the database
    When I click on a report location marker
    Then I should see a popup with information from the report

  Scenario: Filtering reports by population type
    Given I am on the "map" page
    And there is a report with "populationType" "zoological" in the database
    And there is a report with "populationType" "wild" in the database
    When I add a filter where "populationType" is "wild"
    Then I should see 1 report on the map
    When I remove the filters
    Then I should see 2 reports on the map
    When I add a filter where "populationType" is "production"
    Then I should see 0 reports on the map

  Scenario: Grouping reports
    Given I am on the "map" page
    And there is a report with "populationType" "zoological" in the database
    And there is a report with "populationType" "wild" in the database
    When I group the reports by "populationType"
    Then I should see 2 pins with different colors
