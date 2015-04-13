Feature: Group information 
  As an user
  I want to create a group
  So I can share reports with others in my group
  
  Scenario: Creating a group
    Given I have logged in
    When I navigate to the "newGroup" page
    And I fill out the name field with "Test Group"
    And I fill out the description field with "Test Description"
    And I click submit
    Then I should be redirected to the "group/test-group" page
    And I should see the text "Test Group"
    And I should see the text "Test Description"
    And I should see the text "Edit Group Information"
    And I should see the text "Manage users"
    When I log out
    And I navigate to the "group/test-group" page
    Then I should see the text "Test Group"
    And I should see the text "Test Description"
    And I should not see the text "Edit Group Information"
    And I should not see the text "Manage users"
