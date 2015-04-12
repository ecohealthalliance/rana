Feature: The ability to authenticate users
  As a user
  I want to be authenticated
  so the public cannot view and edit my reports

  Scenario: Reports are not publicly visible without consent
    Given I have logged in
    When I navigate to the "study/fakeid/report" page
    And I fill out a report without consenting to publish it
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    When I navigate to the "map" page
    Then my reports without consent should be available
    When I log out
    And I navigate to the "map" page
    Then I am not logged in
    And my reports without consent should not be available
