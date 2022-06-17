@ignore
Feature: Create Customer

  Background:
    * def apiBaseURL = apiBaseURL
    * def pwd = testUserPwd
    * def token = userName + ":" + pwd
    Given url apiBaseURL
    Given header Authorization = token

  @UpdateCustomer
  Scenario: Update customer
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = read("CustomerManagement/testDataRequestJsons/requestBody_updateCust.json")
    And set BodyOfRequest.industryType = updatedIndustryType
    And set BodyOfRequest.name = updatedName
    And set BodyOfRequest.region = updatedRegion
    And set BodyOfRequest.critical = updatedCritical
    And set BodyOfRequest.high = updatedHigh
    And set BodyOfRequest.medium = updatedMedium
    And set BodyOfRequest.id = CustomerId
    And set BodyOfRequest.monitoringSystems[0].id = MonitoringSystemsId
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    * print BodyOfRequest
    When request BodyOfRequest
    And method put
    #  pass test if created success or already exist
    * print response
    Then match responseStatus == expectedUpdateStatus
    * configure abortedStepsShouldPass = true
    * if (response == [] ) karate.abort();
    Then match response.message == expectedUpdateMessage

  @ValidateUpdateCustomer
  Scenario: Verify modified values in Edit api response when another user edits customer
    Given path '/hcapobserve/customer/'
    And header Authorization = UpdatedUserName + ":" + pwd
    And def BodyOfRequest = read("CustomerManagement/testDataRequestJsons/requestBody_updateCust.json")
    And set BodyOfRequest.industryType = updatedIndustryType
    And set BodyOfRequest.name = updatedName
    And set BodyOfRequest.region = updatedRegion
    And set BodyOfRequest.id = CustomerId
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    And set BodyOfRequest.critical = updatedCritical
    And set BodyOfRequest.high = updatedHigh
    And set BodyOfRequest.medium = updatedMedium
    * print BodyOfRequest
    When request BodyOfRequest
    And method put
    * print response
    Then match responseStatus == expectedUpdateStatus
    * def allUsers = call read('User/GetUser.feature@getAllUsers')
    * def getadminUserId_byname = function(arg) { return karate.jsonPath(arg, '$[?(@.username == \'' + userName + '\')].id') }
    * def getadminuserId = call getadminUserId_byname allUsers.response
    * def getObsUserId_byname = function(arg) { return karate.jsonPath(arg, '$[?(@.username == \'' + UpdatedUserName + '\')].id') }
    * def getobsadminuserId = call getObsUserId_byname allUsers.response
    Then match response.industryType == updatedIndustryType
    Then match response.createdBy == getadminuserId[0]
    Then match response.modifiedBy == getobsadminuserId[0]


  @UpdateCustomerWithoutMonitoringSoftware
  Scenario: Update customer
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = { "customerGroups": [{"userIds": [  ],"customerGroupType": "SLO_ADMIN"},{"userIds": [  ],"customerGroupType": "SLO_VIEWER"}]}
    And set BodyOfRequest.industryType = updatedIndustryType
    And set BodyOfRequest.name = updatedName
    And set BodyOfRequest.region = updatedRegion
    And set BodyOfRequest.id = CustomerId
    And set BodyOfRequest.critical = updatedCritical
    And set BodyOfRequest.high = updatedHigh
    And set BodyOfRequest.medium = updatedMedium
    * print BodyOfRequest
    When request BodyOfRequest
    And method put
    * print response
    Then match responseStatus == expectedUpdateStatus
    Then match response.message == expectedUpdateMessage

  @UpdateCustomerWithMonitoringTool
  Scenario: Update customer
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = read("CustomerManagement/testDataRequestJsons/requestBody_updateCust.json")
    And set BodyOfRequest.industryType = updatedIndustryType
    And set BodyOfRequest.name = updatedName
    And set BodyOfRequest.region = updatedRegion
    And set BodyOfRequest.critical = updatedCritical
    And set BodyOfRequest.high = updatedHigh
    And set BodyOfRequest.medium = updatedMedium
    And set BodyOfRequest.id = CustomerId
    And set BodyOfRequest.monitoringSystems[0].id = MonitoringSystemsId
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = updateApiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = updateApplicationId
    * print BodyOfRequest
    When request BodyOfRequest
    And method put
    #  pass test if created success or already exist
    * print response
    Then match responseStatus == expectedUpdateStatus
    * configure abortedStepsShouldPass = true
    * if (response == [] ) karate.abort();
    Then match response.message == expectedUpdateMessage

  @UpdateCustomerWithAlertDetails
  Scenario: Update customer for alert details
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = read("CustomerManagement/testDataRequestJsons/requestBody_updateCust.json")
    And set BodyOfRequest.industryType = updatedIndustryType
    And set BodyOfRequest.name = updatedName
    And set BodyOfRequest.region = updatedRegion
    And set BodyOfRequest.critical = updatedCritical
    And set BodyOfRequest.high = updatedHigh
    And set BodyOfRequest.medium = updatedMedium
    And set BodyOfRequest.id = CustomerId
    And set BodyOfRequest.monitoringSystems[0].id = MonitoringSystemsId
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    And set BodyOfRequest.alertingToolGroups[0].id = alertingToolGroups
    And set BodyOfRequest.alertingToolGroups[0].alertType = alertType
    And set BodyOfRequest.alertingToolGroups[0].groupName = updatedGroupName
    And set BodyOfRequest.alertingToolGroups[0].type = updatedType
    And set BodyOfRequest.alertingToolGroups[0].webhookURL = updateWebhookURL
    * print BodyOfRequest
    When request BodyOfRequest
    And method put
    * print response
    Then match responseStatus == expectedUpdateStatus
    Then match response.alertingToolGroups[0].alertType == alertType
    Then match response.alertingToolGroups[0].groupName == updatedGroupName
    Then match response.alertingToolGroups[0].type == updatedType
    * configure abortedStepsShouldPass = true
    * if (response == [] ) karate.abort();
    Then match response.message == expectedUpdateMessage