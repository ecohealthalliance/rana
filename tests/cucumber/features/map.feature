Feature: A map that plots ranavirus reports
  As a user
  I want to see ranavirus reports plotted on a map
  So I can observe geographic ranavirus trends

  @map
  Scenario: Opening a report popup
    Given I am on the "map" page
    And there is a report with a geopoint in the database
    When I click on a report location marker
    Then I should see a popup with information from the report

  @map
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

  @map
  Scenario: Query expansion for species name synonyms
    Given I am on the "map" page
    And there is a report with "speciesName" "Rana sylvatica" in the database
    And there is a report with "speciesName" "Lithobates sylvaticus" in the database
    When I add a filter where "speciesName" is "Lithobates sylvaticus"
    Then I should see 2 reports on the map

  @map
  Scenario: Filtering by study name
    Given I am on the "map" page
    And there is a report with a geopoint in the database
    When I add a filter where "studyName" is "Test Study"
    Then I should see 1 reports on the map
    When I add a filter where "studyName" is "Something other than test study"
    Then I should see 0 reports on the map

  @map
  Scenario: Filtering by ranavirus confirmation method
    Given I am on the "map" page
    And there is a report with "ranavirusConfirmationMethods" "['immunohistochemistry', 'electron_microscopy']" in the database
    When I add a filter where "ranavirusConfirmationMethods" is "Electron Microscopy"
    Then I should see 1 reports on the map
    When I add a filter where "ranavirusConfirmationMethods" is "Traditional PCR"
    Then I should see 0 reports on the map

  @map
  Scenario: Grouping reports
    Given I am on the "map" page
    And there is a report with "populationType" "zoological" in the database
    And there is a report with "populationType" "wild" in the database
    When I group the reports by "populationType"
    Then I should see 2 pins with different colors

  @map
  Scenario: Grouping reports by ranavirus confirmation method
    Given I am on the "map" page
    And there is a report with "ranavirusConfirmationMethods" "['immunohistochemistry', 'electron_microscopy']" in the database
    And there is a report with "ranavirusConfirmationMethods" "['immunohistochemistry']" in the database
    When I group the reports by "ranavirusConfirmationMethods"
    Then I should see 2 pins with different colors
