Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Filling out a form without logged in
    Given I am not logged in
    And I am on the "form" page
    Then I will see a message that requires me to log in
  
  Scenario: Filling in institution information
    Given I am logged in
    And I am on the "form" page
    Then the information for the institution fields should be prepopulated
    
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I fill out the form with the name "Test user"
    And I click submit
    Then the database should have a report with the name "Test user"

  Scenario: Submitting an invalid email
    Given I am on the "form" page
    When I fill out the form with the email "invalid"
    And I click submit
    Then the webpage should display a validation error
    And the database should not have a report with the email "invalid"
    
# Are we sure these number of digits won't inadvertantly prevent people
# from signing up?
  Scenario: Submitting an invalid phone number
    Given I am on the "form" page
    When I fill out the form with a telephone number greater than 15 digits
    And I click submit
    Then the webpage should display a validation error
    
  Scenario: Submitting an invalid phone number
    Given I am on the "form" page
    When I fill out the form with a telephone number less than 12 digits
    And I click submit
    Then the webpage should display a validation error
  
  Scenario: Submitting an invalid date
    Given I am on the "form" page
    When I fill out the form with the date "08/dd/1990"
    And I click submit
    Then the website should display the question "No date specified. Would you like to submit anyways?"

  Scenario: Submitting a file without permission
    Given I fill out a form
    And I select "Permission Not Granted"
    And I choose a file to upload
    When I click submit
    Then the website should display a validation error
    And the database should not have a report containing the uploaded file

  Scenario: Submitting a non-PDF publication
    Given I fill out a form
    And I choose a non-PDF publication to upload
    When I click submit
    Then the webpage should display a validation error

  Scenario: Submitting a publication without a reference
    Given I fill out a form
    And I upload a pdf publication
    But I do not provide text for the reference field
    When I click submit
    Then the webpage should display a validation error
