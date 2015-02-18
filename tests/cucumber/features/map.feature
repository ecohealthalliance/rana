Feature: A map that plots ranavirus reports
  As a user
  I want to see ranavirus reports plotted on a map
  So I can observe geographic ranavirus trends

  Scenario: Opening a report popup
    Given I am on the "map" page
    And there is a report with a geopoint in the database
    When I click on a report location marker
    Then I should see a popup with information from the report
