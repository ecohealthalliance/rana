Feature: Report approval
  As an user with an admin account
  I want to be able to approve reports from normal users
  So reports are vetted before they are public

  Scenario: Creating a report from a non-approved account
    When I register an account
    And I am on the "study/fakeid/report" page
    And I fill out the form
    And I click submit
    And I navigate to the "table" page
    Then I should see 1 report in the table
    When I log out
    And I navigate to the "table" page
    Then I should see 0 reports in the table

  Scenario: Visiting pending when there are no pending reports
    When I have logged in as admin
    And I am on the "pending" page
    Then I should see 0 reports in the table

  Scenario: Approving a report
    When I register an account
    And I am on the "study/fakeid/report" page
    And I fill out the form
    And I click submit
    And I log out
    And I have logged in as admin
    When I am on the "table" page
    Then I should see 0 reports in the table
    When I am on the "pending" page
    Then I should see 1 report in the table
    When I approve the report
    Then I should see 0 reports in the table
    When I am on the "table" page
    Then I should see 1 report in the table

  Scenario: Approving a user
    When I register an account
    And I am on the "study/fakeid/report" page
    And I fill out the form
    And I click submit
    And I am on the "study/fakeid/report" page
    And I fill out the form
    And I click submit
    And I log out
    And I have logged in as admin
    When I am on the "table" page
    Then I should see 0 reports in the table
    When I am on the "pending" page
    Then I should see 2 reports in the table
    When I approve the user
    Then I should see 0 reports in the table
    When I am on the "table" page
    Then I should see 2 reports in the table
