@ignore
Feature: Get Users

  Background:
    * def apiBaseURL = apiBaseURL
    * def token = adminToken
    Given url apiBaseURL
    Given header Authorization = token

  @getAllUsers
  Scenario: Get all users
    Given path '/user'
    When method get
    Then status 200




