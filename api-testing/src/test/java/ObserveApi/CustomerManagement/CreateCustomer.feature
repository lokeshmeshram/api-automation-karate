@ignore
Feature: Create Customer

  Background:
    * def apiBaseURL = apiBaseURL
    * def pwd = testUserPwd
    * def token = userName + ":" + pwd
    Given url apiBaseURL
    Given header Authorization = token

  @CreateCustomer
  Scenario: Create new customer
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = read("CustomerManagement/testDataRequestJsons/requestBody.json")
    And set BodyOfRequest.industryType = industryType
    And set BodyOfRequest.name = customerName
    And set BodyOfRequest.region = region
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    * print msg
    Then match msg == expectedMessage

  @CreateCustomerWithNameOnly
  Scenario: Create new customer with only name parameter
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = { "customerGroups": [{"userIds": [  ],"customerGroupType": "SLO_ADMIN"},{"userIds": [  ],"customerGroupType": "SLO_VIEWER"}]}
    And set BodyOfRequest.name = customerName
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    Then match msg == expectedMessage

  @CreateCustomerWithoutMonitoringSoftware
  Scenario: Create new customer without Monitoring Software
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = { "customerGroups": [{"userIds": [  ],"customerGroupType": "SLO_ADMIN"},{"userIds": [  ],"customerGroupType": "SLO_VIEWER"}]}
    And set BodyOfRequest.industryType = industryType
    And set BodyOfRequest.name = customerName
    And set BodyOfRequest.region = region
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    Then match msg == expectedMessage

  @CreateCustomerWithMultipleMonitoringTools
  Scenario: Create new customer
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = {"monitoringSystems": [{"credentialsKeyValue": {"apiKey": "","applicationId": ""},"monitoringToolType": ""},{"credentialsKeyValue": {"apiKey": "","applicationId": ""},"monitoringToolType": ""}],"customerGroups": [{"userIds": [  ],"customerGroupType": "SLO_ADMIN"},{"userIds": [  ],"customerGroupType": "SLO_VIEWER"}]}
    And set BodyOfRequest.industryType = industryType
    And set BodyOfRequest.name = customerName
    And set BodyOfRequest.region = region
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    And set BodyOfRequest.monitoringSystems[1].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[1].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[1].credentialsKeyValue.apiKey = updateApiKey
    And set BodyOfRequest.monitoringSystems[1].credentialsKeyValue.applicationId = updateApplicationId
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    * print msg
    Then match msg == expectedMessage

  @CreateCustomerWithInvalidCredentials
  Scenario: Create Customer With Invalid Credentials
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = read("CustomerManagement/testDataRequestJsons/requestBody.json")
    And set BodyOfRequest.industryType = industryType
    And set BodyOfRequest.name = customerName
    And set BodyOfRequest.region = region
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey + 'test'
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId + 'test'
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    * print msg
    Then match msg == expectedMessage

  @ValidateMonitoringToolConnection
  Scenario: Validate Monitoring tool Connection
    Given path '/hcapobserve/customer/checkconnection'
    And def BodyOfRequest = {}
    And set BodyOfRequest.monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.credentialsKeyValue.applicationId = applicationId
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * print response.message

  @CreateCustomerWithoutWithoutMandatoryFields
  Scenario: Try Create new customer without Mandatory field
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = {"monitoringSystems": [{"credentialsKeyValue": {"apiKey": "","applicationId": ""},"monitoringToolType": ""}],"customerGroups": [{"userIds": [  ],"customerGroupType": "SLO_ADMIN"},{"userIds": [  ],"customerGroupType": "SLO_VIEWER"}]}
    * def SetCustomerName = customerName == "RemoveKey" ? delete BodyOfRequest.name : BodyOfRequest.name = customerName ;
    * def SetMonitoringSystemName = monitoringSystemName == "RemoveKey" ? delete BodyOfRequest.monitoringSystems[0].monitoringSystemName : BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName ;
    * def SetIndustryType = industryType == "RemoveKey" ? delete BodyOfRequest.industryType : BodyOfRequest.industryType = industryType ;
    * def SetRegion = region == "RemoveKey" ? delete BodyOfRequest.region : BodyOfRequest.region = region ;
    * def SetCritical = Critical == "RemoveKey" ? delete BodyOfRequest.critical : BodyOfRequest.critical = Critical ;
    * def SetHigh = High == "RemoveKey" ? delete BodyOfRequest.high : BodyOfRequest.high = High ;
    * def SetMedium = Medium == "RemoveKey" ? delete BodyOfRequest.medium : BodyOfRequest.medium = Medium ;
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    Then match msg == expectedMessage

  @CreateCustomerWithAlert
  Scenario: Create new customer with alert
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = { "alertingToolGroups": [{"alertType": "","groupName": "","type": "","webhookURL": ""}] ,"customerGroups": [{"userIds": [  ],"customerGroupType": "SLO_ADMIN"},{"userIds": [  ],"customerGroupType": "SLO_VIEWER"}]}
    And set BodyOfRequest.industryType = industryType
    And set BodyOfRequest.name = customerName
    And set BodyOfRequest.region = region
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    And set BodyOfRequest.alertingToolGroups[0].alertType = alertType
    And set BodyOfRequest.alertingToolGroups[0].groupName = AlertGroupName
    And set BodyOfRequest.alertingToolGroups[0].type = type
    And set BodyOfRequest.alertingToolGroups[0].webhookURL = webhookURL
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    And retry until responseStatus == expectedStatus
    Then match responseStatus == expectedStatus
    Then match response.alertingToolGroups[0].alertType == alertType
    Then match response.alertingToolGroups[0].groupName == AlertGroupName
    Then match response.alertingToolGroups[0].type == type
    * print response.message
    Then match response.message == expectedMessage

  @CreateCustomerWithMultipleAlert
  Scenario: Create new customer with multiple alert
    Given path '/hcapobserve/customer/'
    And def BodyOfRequest = { "alertingToolGroups": [{"alertType": "","groupName": "","type": "","webhookURL": ""},{"alertType": "","groupName": "","type": "","webhookURL": ""}] ,"customerGroups": [{"userIds": [  ],"customerGroupType": "SLO_ADMIN"},{"userIds": [  ],"customerGroupType": "SLO_VIEWER"}]}
    And set BodyOfRequest.industryType = industryType
    And set BodyOfRequest.name = customerName
    And set BodyOfRequest.region = region
    And set BodyOfRequest.monitoringSystems[0].monitoringToolType = monitoringToolType
    And set BodyOfRequest.monitoringSystems[0].monitoringSystemName = monitoringSystemName
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.apiKey = apiKey
    And set BodyOfRequest.monitoringSystems[0].credentialsKeyValue.applicationId = applicationId
    And set BodyOfRequest.alertingToolGroups[0].alertType = alertType
    And set BodyOfRequest.alertingToolGroups[0].groupName = AlertGroupName
    And set BodyOfRequest.alertingToolGroups[0].type = type
    And set BodyOfRequest.alertingToolGroups[0].webhookURL = webhookURL
    And set BodyOfRequest.alertingToolGroups[1].alertType = alertType
    And set BodyOfRequest.alertingToolGroups[1].groupName = updatedGroupName
    And set BodyOfRequest.alertingToolGroups[1].type = updatedType
    And set BodyOfRequest.alertingToolGroups[1].webhookURL = updateWebhookURL
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    * print BodyOfRequest
    When request BodyOfRequest
    And method post
    * print response
    And retry until responseStatus == expectedStatus
    Then match responseStatus == expectedStatus
    Then match response.alertingToolGroups[0].alertType == alertType
    Then match response.alertingToolGroups[0].groupName == AlertGroupName
    Then match response.alertingToolGroups[0].type == type
    Then match response.alertingToolGroups[1].alertType == alertType
    Then match response.alertingToolGroups[1].groupName == updatedGroupName
    Then match response.alertingToolGroups[1].type == updatedType
    * print response.message
    Then match response.message == expectedMessage