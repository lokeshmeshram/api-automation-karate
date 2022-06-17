@ignore
Feature: Data CleanUp at end of tests

  Background:
    * configure cookies = null
    * def tests = call read('TestData.feature')
    * def apiBaseURL = apiBaseURL
    * def token = adminToken
    Given url apiBaseURL
    Given header Authorization = token

  Scenario Outline: Disable User,Remove from Group and Delete Group
    * def allUsers = call read('User/getUser.feature@getAllUsers')
    * def getId_byname = function(arg) { return karate.jsonPath(arg, '$[?(@.username == \'' + userName + '\')].id') }
    * def getuserId = call getId_byname allUsers.response
    * def allGroups = call read('Group/GetGroup.feature@getAllGroups')
    * def getId = function(arg) { return karate.jsonPath(arg, '$[?(@.name == \'' + groupName + '\')].id') }
    * def getGroupId = call getId allGroups.response
    #Disable User
    Given path '/user/share-entities/',getuserId[0],'/-1'
    And request ''
    And method put
    Then status 200
    #Remove uses from group
    Given path '/authz/group/users/detach'
    And header Authorization = token
    And def BodyOfRequest = read("User/testDataRequestJsons/requestBody_assignGrp.json")
    And set BodyOfRequest[0].groupId = getGroupId[0]
    And set BodyOfRequest[0].userId = getuserId[0]
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    Then status 200
    #Delete Group
    Given path '/authz/group/'+getGroupId[0]
    And header Authorization = token
    And method delete
    Then status 200
    * def expectedOutput = 'Group deleted successfully.'
    And match response == expectedOutput

    Examples:
      | tests.testData |