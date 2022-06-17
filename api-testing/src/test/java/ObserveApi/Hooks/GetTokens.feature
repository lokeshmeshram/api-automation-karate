Feature: get access token and refresh token
  Background:
    * def BaseURL = BaseURL

  Scenario: Generate access token and refresh token
    Given url BaseURL
    Given path 'login'
    * def adminRequestEntity = "{\"username\":\"" + userName + "\",\"password\":\"" + testUserPwd + "\"}"
    And request adminRequestEntity
    When method post
    Then match responseStatus == 200
