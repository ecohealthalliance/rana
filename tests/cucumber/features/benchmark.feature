Feature: Ability to handle many reports

  Scenario: Creating lots of reports
    Given there are 1000 reports in the database
    When I navigate to the "map" page
    Then I should see 1000 reports on the map
    