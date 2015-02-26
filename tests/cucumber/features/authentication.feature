Feature: The ability to authenticate users
  As a user
  I want to be authenticated
  so the public cannot view and edit my reports

  Scenario: Reports are not publicly visible without consent
    Given I have not logged in
    When I am on the "form" page
    And I log in
    When I create a report without consenting to publish it
    And I navigate to the "map" page
    Then my reports without consent should be available
    When I log out
    And I navigate to the "map" page
    Then I am not logged in
    And my reports without consent should not be available
