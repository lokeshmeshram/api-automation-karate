@ignore
Feature: Create User and Assign to Group

  Background:
    * def apiBaseURL = apiBaseURL
    * def token = adminToken
    * def pwd = testUserPwd
    Given url apiBaseURL
    Given header Authorization = token

  Scenario: Create Users in Admin Console
    Given path '/admin-backend/adminuser'
    And def BodyOfRequest = read("User/testDataRequestJsons/requestBody.json")
    And set BodyOfRequest.name = name
    And set BodyOfRequest.email = email
    And set BodyOfRequest.userAuthentication.password = pwd
    And set BodyOfRequest.username = userName
    And set BodyOfRequest.verified = verified
    And set BodyOfRequest.disabled = disabled
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    #    pass test if created success or already exist
    Then assert responseStatus == 200 || responseStatus == 403

  Scenario: Create Users and assign to group in Admin Console
    # get all groups and users
    # get group id and user id from responses
    * def allGroups = call read('Group/GetGroup.feature@getAllGroups')
    * def getId = function(arg) { return karate.jsonPath(arg, '$[?(@.name == \'' + groupName + '\')].id') }
    * def getGroupId = call getId allGroups.response
    * def allUsers = call read('User/GetUser.feature@getAllUsers')
    * def getId_byname = function(arg) { return karate.jsonPath(arg, '$[?(@.username == \'' + userName + '\')].id') }
    * def getuserId = call getId_byname allUsers.response
    # assign user to group by id
    Given path '/authz/group/users'
    And def BodyOfRequest = read("User/testDataRequestJsons/requestBody_assignGrp.json")
    And set BodyOfRequest[0].groupId = getGroupId[0]
    And set BodyOfRequest[0].userId = getuserId[0]
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    Then status 200
