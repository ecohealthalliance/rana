Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Filling out a form without logging in
    Given I have not logged in
    And I am on the "report" page
    Then I will see a message that requires me to log in

  Scenario: Filling in institution information
    Given I register an account
    And I have logged in
    And I am on the "report" page
    Then the information for the institution fields should be prepopulated

  Scenario: Submitting a ranavirus form
    Given I register an account
    And I am on the "report" page
    And I have logged in
    When I fill out the form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And the database should have a report linked to my account

  Scenario: Uploading an image
    Given I have logged in
    And I am on the "report" page
    When I upload an image
    Then I should see an image preview
