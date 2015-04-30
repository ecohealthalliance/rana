Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Obfuscated reports show only contact information and country
    Given I have logged in
    When I navigate to the "study/fakeid/report" page
    And I fill out a report with obfuscated permissions
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    When I log out
    And I register an account
    And I navigate to the "table" page
    And I click on the view button
    Then the webpage should not display the speciesGenus field
    And the contact.name field should have the value "Fake Name"


