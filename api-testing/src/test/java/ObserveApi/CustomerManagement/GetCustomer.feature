@ignore
Feature: Create Customer

  Background:
    * def apiBaseURL = apiBaseURL
    * def pwd = testUserPwd
    * def token = userName + ":" + pwd
    Given url apiBaseURL
    Given header Authorization = token

  @getAllCustomer
  Scenario: Get all Customers
    Given path '/hcapobserve/customer/'
    When method get
    Then status 200
    * print response

  @getSpecificCustomer
  Scenario: Get specific Customers
    Given path '/hcapobserve/customer/'+ customerId
    When method get
    Then status 200
    * print response
    Then match response.name == customerName
    Then match response.industryType == industryType
    Then match response.region == region
    Then match response.critical == Critical
    Then match response.high == High
    Then match response.medium == Medium
    Then match response.monitoringSystems[0].monitoringToolType == monitoringToolType
#    Then match response.createdByName == userName

  @GetIndustryTypeValues
  Scenario: Get Industry Type Values
    Given path '/hcapobserve/customer/industrytypes'
    When method get
    Then status 200
    * print response
    Then match response == ["Aerospace","Transport","Computer","Telecommunication","Agriculture","Construction","Education","Pharmaceutical","Food","HealthCare"]

  @GetRegionValues
  Scenario: Get Region Values
    Given path '/hcapobserve/customer/regions'
    When method get
    Then status 200
    * print response
    Then match response == ["APAC","EMEA","AMER"]

  @GetAllSupportedMonitoringToolsList
  Scenario: Get All Supported Monitoring Tools List
    Given path '/hcapobserve/customer/tools'
    When method get
    Then status 200
    * print response
    Then match response == {"Azure": ["applicationId","apiKey"]}

  @GetAllServicesForMonitoringSystem
  Scenario: Get All Services For MonitoringSystem
    Given path '/hcapobserve/customer/services/'+ customerId +'/'+ monitoringSystemId
    When method get
    Then status 200
    * print response