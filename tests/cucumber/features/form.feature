Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I fill out the form with the name "Test user"
    And I click submit
    Then the database should have a report with the name "Test user"

  Scenario: Submitting an invalid ranavirus form
    Given I am on the "form" page
    When I fill out the form with the email "invalid"
    And I click submit
    Then the database should not have a report with the email "invalid"

  Scenario: Submitting an invalid ranavirus form field 
    Given I am on the "form" page
    When I fill out the form with the telephone number "greater than 15 digits"
    And I click submit
    Then the website should display error, "too many digits"
    
  Scenario: Submitting an invalid ranavirus form field 
    Given I am on the "form" page
    When I fill out the form with the telephone number "less than 12 digits"
    And I click submit
    Then the website should display error, "too few digits"
      
      
