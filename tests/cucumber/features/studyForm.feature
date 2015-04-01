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
    Then the publication should not appear

  Scenario: Submitting a publication without a reference
    Given I have logged in
    And I am on the "study" page
    When I fill out the study form
    And I upload a pdf publication
    Then the publication should appear
    When I fill out the publicationInfo.reference field with "the journal Nature"
    And I click submit
    Then the webpage should not display a validation error
    And I should see a "insert successful" toast

