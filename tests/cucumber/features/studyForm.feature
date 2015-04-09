Feature: A form for setting up a ranavirus study
  As a user
  I want to set up a ranavirus study
  So I can add reports individually or import them

  Scenario: Filling in institution information
    Given I register an account
    And I have logged in
    And I am on the "study" page
    Then the information for the institution fields should be prepopulated

  Scenario: Submitting a non-pdf publication
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I upload a non-pdf publication
    And I click submit
    Then the webpage should display a validation error

  Scenario: Submitting a publication without a reference
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I upload a pdf publication
    But I do not provide text for the reference field
    And I click submit
    Then the webpage should display a validation error
    When I fill out the publicationInfo.reference field with "the journal Nature"
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast

  Scenario: Updating a study
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    And I click on the edit link in the toast
    And I fill out the study form differently
    And I click submit
    Then the form should contain the different values I entered

  Scenario: Removing a study
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast
    When I navigate to the "studyTable" page
    And I click the "Remove" button
    And I type "delete" into the prompt
    And I accept the prompt
    Then I should not see the text "No Studies Found"
    When I click the "Remove" button
    And I type "delete" into the prompt
    And I accept the prompt
    Then I should see the text "No Studies Found"
