Feature: Report Review
  As a user
  I want to leave and view ratings and comments on reports
  So I can provide feedback and assess report quality

  Scenario: Adding a rating
    Given I have logged in
    And there is a report in the database
    When I navigate to the "table" page
    And I click on the edit button
    Then I should see the text "Reviews"
    When I open the review panel
    Then I should see the text "New Review"
    When I enter the rating 9
    And I add the review
    Then the review panel should appear
    And I should see the text "Rating 9 / 10"

  Scenario: Adding a rating and a comment
    Given I have logged in
    And there is a report in the database
    When I navigate to the "table" page
    And I click on the edit button
    Then I should see the text "Reviews"
    When I open the review panel
    Then I should see the text "New Review"
    When I enter the rating 3
    And I enter the comment "This report is incomplete"
    And I add the review
    Then the review panel should appear
    And I should see the text "Rating 3 / 10"
    And I should see the text "This report is incomplete\nTest User"

  Scenario: Adding an invalid rating
    Given I have logged in
    And there is a report in the database
    When I navigate to the "table" page
    And I click on the edit button
    Then I should see the text "Reviews"
    When I open the review panel
    Then I should see the text "New Review"
    When I enter the rating 99999
    And I add the review
    Then the review panel should not appear