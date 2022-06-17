@ignore
Feature: Get All SLO

  Background:
    * def apiBaseURL = apiBaseURL
    * def pwd = testUserPwd
    * def token = userName + ":" + pwd
    Given url apiBaseURL
    Given header Authorization = token
    * def getStartTime =
    """
    function() {
    var date = new Date();
    var yesterday = new Date(date.getTime() - (1000*60*60*24));
    return yesterday.getTime()
    }
    """
    * def getEndTime =
    """
    function() {
    var date = new Date();
    var timestamp = date.getTime();
    return timestamp
    }
    """

  @getAllSLO
  Scenario: Get all Slo
    Given path '/hcapobserve/slo/'
    When method get
    Then status 200

  @getSLoViolations
  Scenario:get SLO Violations
    * def startTime = call getStartTime
    * print startTime
    * def endTime = call getEndTime
    * print endTime
    Given path '/hcapobserve/slo/violations'
    And def BodyOfRequest = read("SLOManagement/testDataRequestJsons/getSLODetails.json")
    And set BodyOfRequest.endTime = endTime
    And set BodyOfRequest.startTime = startTime
    And set BodyOfRequest.sloId = sloId
    When request BodyOfRequest
    * print BodyOfRequest
    And method post
    * print response
    Then status 200
    * print 'Total SLO Violations are : ' + response.totalViolations

  @getErrorBudgetDetails
  Scenario:get SLO Violations
    * def startTime = call getStartTime
    * print startTime
    * def endTime = call getEndTime
    * print endTime
    Given path '/hcapobserve/slo/errorBudgetDetails'
    And def BodyOfRequest = read("SLOManagement/testDataRequestJsons/getSLODetails.json")
    And set BodyOfRequest.endTime = endTime
    And set BodyOfRequest.startTime = startTime
    And set BodyOfRequest.sloId = sloId
    When request BodyOfRequest
    * print BodyOfRequest
    And method post
    * print response
    Then status 200

  @getFailedAndSuccessfulTransactions
  Scenario:get SLO Violations
    * def startTime = call getStartTime
    * print startTime
    * def endTime = call getEndTime
    * print endTime
    Given path '/hcapobserve/slo/transactions'
    And def BodyOfRequest = read("SLOManagement/testDataRequestJsons/getSLODetails.json")
    And set BodyOfRequest.endTime = endTime
    And set BodyOfRequest.startTime = startTime
    And set BodyOfRequest.sloId = sloId
    When request BodyOfRequest
    * print BodyOfRequest
    And method post
    * print response
    Then status 200

  @getSLOsByIds
  Scenario:get SLO by Id
    Given path '/hcapobserve/slo/getSLOsByIds'
    And def BodyOfRequest = []
    And set BodyOfRequest[0] = sloId
    When request BodyOfRequest
    * print BodyOfRequest
    And method post
    * print response
    Then status 200

  @getslochangehistory
  Scenario:get slo change history using Id
    Given path '/hcapobserve/slo/slochangehistory/'+ sloId
    And method get
    Then status 200
    * print response

  @getSLOPerformanceTrendDetails
  Scenario:get SLO Performance Trend Details
    * def startTime = call getStartTime
    * print startTime
    * def endTime = call getEndTime
    * print endTime
    Given path '/hcapobserve/slo/performanceCorrelation'
    And def BodyOfRequest = read("SLOManagement/testDataRequestJsons/getSLODetails.json")
    And set BodyOfRequest.endTime = endTime
    And set BodyOfRequest.startTime = startTime
    And set BodyOfRequest.sloId = sloId
    When request BodyOfRequest
    * print BodyOfRequest
    And method post
    * print response
    Then status 200