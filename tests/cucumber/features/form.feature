Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

Scenario: Submitting a ranavirus form
  Given I am on the "form" page
  If I have not filled out my account information
  Then I will be unable to interact with the form

Scenario: Submitting a ranavirus form
  Given I am on the "form" page
  When I begin to type information for the institution fields 
  Then the institution associated with group account information will be suggested to fill in the institution information

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

  Scenario: Submitting an invalid ranavirus form
    Given I am on the "form" page
    When I fill out the form with the email "invalid"
    And I click submit
    Then the website should display error
    
  Scenario: Submitting an invalid ranavirus form field 
    Given I am on the "form" page
    When I fill out the form with the telephone number "greater than 15 digits"
    And I click submit
    Then the website should display error
    
  Scenario: Submitting an invalid ranavirus form field 
    Given I am on the "form" page
    When I fill out the form with the telephone number "less than 12 digits"
    And I click submit
    Then the website should display error
  
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I fill out the form with the date "08/dd/1990"
    And I click submit
    Then the website should display question "No day specified. Would you like to submit anyways?"
    
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I select "Permission Not Granted" and choose a file to upload
    And I click submit
    Then the database should not have a report containing the uploaded file
    
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I select "Permission Not Granted" and choose a file to upload
    And I click submit
    Then the website should display error, "permission not granted" 
    
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I select "Unpublished" and choose a PDF file to upload
    And I click submit
    Then the database should not have a report containing the uploaded PDF
    
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I select "Unpublished" and choose a file to upload
    And I click submit
    Then the database should not have a report containing the uploaded file
    
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I select "published" and choose a non-PDF file to upload
    And I click submit
    Then the database should not have a report containing the non-PDF file
    
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I select "published" and choose a non-PDF file to upload
    And I click submit
    Then the website should display error, "please submit PDF files only"
    
  Scenario: Submitting a ranavirus form
    Given I am on the "form" page
    When I select "published" and choose a file to upload, but do not provide text for the reference field
    And I click submit
    Then the website should display, "please provide a full reference"

    
