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

  Scenario: Visiting the pending page without logging in
    When I am on the "pending" page
    Then I should be on the "grrs/" page

  Scenario: Visiting the pending page when logged in as a non-admin
    When I have logged in
    And I am on the "pending" page
    Then I should be on the "grrs/" page

  Scenario: Changing the sharing of an approved report by pending user
    When I log in as pending
    And I am on the "study/fakeid/report" page
    And I fill out the form setting "dataUsePermissions" to "Share obfuscated"
    And I click submit
    And I log out
    And I have logged in as admin
    And I am on the "pending" page
    And I approve the report
    And I log out
    And I am on the "table" page
    Then I should see 1 report in the table
    When I log in as pending
    And I am on the "table" page
    And I click on the edit button
    And I fill out the form setting "dataUsePermissions" to "Share full record"
    And I click submit
    And I log out
    And I am on the "table" page
    Then I should see 0 reports in the table

  Scenario: Changing the sharing of an approved report by approved user
    When I log in
    And I am on the "study/fakeid/report" page
    And I fill out the form setting "dataUsePermissions" to "Share obfuscated"
    And I click submit
    And I log out
    And I am on the "table" page
    Then I should see 1 report in the table
    When I log in
    And I am on the "table" page
    And I click on the edit button
    And I fill out the form setting "dataUsePermissions" to "Share full record"
    And I click submit
    And I log out
    And I am on the "table" page
    Then I should see 1 report in the table

  Scenario: Changing approval status from the report page
    When I log in
    And I am on the "study/fakeid/report" page
    And I fill out the form
    And I click submit
    And I log out
    And I log in as admin
    And I navigate to the "table" page
    And I click on the view button
    Then I should see the "reject-report" approval button
    And I should see the "pend-report" approval button
    And I should see the "reject-user" approval button
    And I should see the "pend-user" approval button
    When I click on the "reject-report" approval button
    Then I should see the "approve-report" approval button
    And I should see the "pend-report" approval button
    And I should see the "pend-user" approval button
    And I should see the "reject-user" approval button
    When I click on the "pend-report" approval button
    Then I should see the "approve-report" approval button
    And I should see the "reject-report" approval button
    And I should see the "reject-user" approval button
    And I should see the "pend-user" approval button
    When I click on the "approve-report" approval button
    Then I should see the "pend-report" approval button
    And I should see the "reject-report" approval button
    And I should see the "reject-user" approval button
    And I should see the "pend-user" approval button
    When I click on the "pend-report" approval button
    And I click on the "reject-user" approval button
    Then I should see the "approve-report" approval button
    And I should see the "pend-report" approval button
    And I should see the "approve-user" approval button
    And I should see the "pend-user" approval button
    When I click on the "pend-report" approval button
    And I click on the "approve-user" approval button
    Then I should see the "pend-report" approval button
    And I should see the "reject-report" approval button
    And I should see the "reject-user" approval button
    And I should see the "pend-user" approval button
    When I click on the "reject-report" approval button
    And I click on the "pend-user" approval button
    Then I should see the "pend-report" approval button
    And I should see the "approve-report" approval button
    And I should see the "approve-user" approval button
    And I should see the "reject-user" approval button
