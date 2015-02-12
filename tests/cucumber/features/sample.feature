Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I fill out the form with the name "Test user"
    And I click submit
    Then the database should have a report with the name "Test user"
