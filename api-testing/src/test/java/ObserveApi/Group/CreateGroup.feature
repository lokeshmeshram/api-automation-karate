@ignore
Feature: CreateGroups

  Background:
    * def apiBaseURL = apiBaseURL
    * def token = adminToken
    Given url apiBaseURL
    Given header Authorization = token

  Scenario: Create Groups in Admin Console
    Given path '/authz/group'
    And def BodyOfRequest = read("Group/testDataRequestJsons/requestBody.json")
    And set BodyOfRequest.name = groupName
    And set BodyOfRequest.description = "created by Observe API Automation"
    And set BodyOfRequest.groupLevelSharing = groupLevelSharing
    And set BodyOfRequest.policies = policies
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    #  pass test if created success or already exist
    Then match responseStatus == 200 || responseStatus == 405
