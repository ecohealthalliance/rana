Feature: A form for reporting Ranavirus outbreaks
  As a user
  I want to fill out a form to report ranavirus events
  So I can submit the data for analysis

  Scenario: Redirecting after report submission
    Given I have logged in
    And I am on the "study/fakeid/report" page
    And I have logged in
    When I fill out the form
    And I click submit
    And I navigate to the "table" page
    And I click on the edit button
    And I click submit
    Then I should be on the "table" page

