@ignore
Feature: Get Groups

  Background:
    * def apiBaseURL = apiBaseURL
    * def token = adminToken
    Given url apiBaseURL
    Given header Authorization = token

  @getAllGroups
  Scenario: Get Group
    Given path '/authz/group'
    When method get
    Then status 200



