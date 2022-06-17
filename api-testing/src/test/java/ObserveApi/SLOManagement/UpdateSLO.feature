@ignore
Feature: Update SLO

  Background:
    * def apiBaseURL = apiBaseURL
    * def pwd = testUserPwd
    * def token = userName + ":" + pwd
    Given url apiBaseURL
    Given header Authorization = token

  @UpdateSlo
  Scenario: Update SLO
    Given path '/hcapobserve/slo/'
    And def BodyOfRequest = read("SLOManagement/testDataRequestJsons/updateSLORequestBody.json")
    * def GetApplicationService = call read('CustomerManagement/GetCustomer.feature@GetAllServicesForMonitoringSystem') { customerId : '#(CustomerId)' ,monitoringSystemId : '#(MonitoringSystemsId)' }
    * print GetApplicationService.response
    * def ApplicationService = GetApplicationService.response[0]
    * print SLOType
    And set BodyOfRequest.applicationService = ApplicationService
    And set BodyOfRequest.customerId = CustomerId
    And set BodyOfRequest.monitoringSystemId = MonitoringSystemsId
    And set BodyOfRequest.name = SLOName
    And set BodyOfRequest.id = SloId
    And set BodyOfRequest.sloType = SLOType
    And set BodyOfRequest.target = target
    And set BodyOfRequest.windowType = windowType
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    * def SetCalenderTimeWindow = BodyOfRequest.windowType == "Rolling" ?  BodyOfRequest.timeWindow = timeWindow :  BodyOfRequest.timeWindow = null ;
    * def SetCalendarPeriod = BodyOfRequest.windowType == "Calendar" ?  BodyOfRequest.calendarPeriod =  calendarPeriod :  BodyOfRequest.calendarPeriod = null ;
    * eval if ( BodyOfRequest.sloType == "Latency" )  BodyOfRequest.inputs[0].name = "duration" ;
    * eval if ( BodyOfRequest.sloType == "Latency" )  BodyOfRequest.inputs[0].value = Duration ;
    * eval if ( BodyOfRequest.sloType == "Latency" )  BodyOfRequest.inputs[1].name = "timeunit" ;
    * eval if ( BodyOfRequest.sloType == "Latency" )  BodyOfRequest.inputs[1].value = Timeunit ;
    When request BodyOfRequest
    * print BodyOfRequest
    And method put
    * print response
    Then match responseStatus == expectedStatus
    Then match response.name == sloname
    Then match response.windowType == windowType
    Then match response.customer.id == CustomerId
    Then match response.applicationService == ApplicationService
    Then match response.sloType == SLOType
    Then match response.target == target
    Then match response.critical == Critical
    Then match response.high == High
    Then match response.medium == Medium
    Then match response.applicationService == ApplicationService

  @UpdateSloInvalidData
  Scenario: Update SLO with Invalid Data
    Given path '/hcapobserve/slo/'
    And def BodyOfRequest = {}
    * def SetSLOApplicationService = SLOApplicationService == 'RemoveKey' ? delete BodyOfRequest.applicationService : BodyOfRequest.applicationService = ApplicationService ;
    * def SetSLOName = SLOName == 'RemoveKey' ? delete BodyOfRequest.name : BodyOfRequest.name = SLOName ;
    * def SetSLOCustomerId = CustomerId == 'RemoveKey' ? delete BodyOfRequest.customerId : BodyOfRequest.customerId = CustomerId ;
    * def SetSLOMonitoringSystemId = MonitoringSystemsId == 'RemoveKey' ? delete BodyOfRequest.monitoringSystemId : BodyOfRequest.monitoringSystemId = MonitoringSystemsId ;
    * def SetSLOId = SloId == 'RemoveKey' ? delete BodyOfRequest.id : BodyOfRequest.id = SloId ;
    * def SetSLOType = SLOType == 'RemoveKey' ? delete BodyOfRequest.sloType : BodyOfRequest.sloType = SLOType ;
    * def SetSLOWindowType = SLOWindowType == 'RemoveKey' ? delete BodyOfRequest.windowType : BodyOfRequest.windowType = SLOWindowType ;
    * def SetSLOCriticalThreshold = CriticalThreshold == 'RemoveKey' ? delete BodyOfRequest.critical : BodyOfRequest.critical = CriticalThreshold ;
    * def SetSLOHighThreshold = HighThreshold == 'RemoveKey' ? delete BodyOfRequest.high : BodyOfRequest.high = HighThreshold ;
    * def SetSLOMediumThreshold = MediumThreshold == 'RemoveKey' ? delete BodyOfRequest.medium : BodyOfRequest.medium = MediumThreshold ;
    * def SetSLOTarget = SLOTarget == 'RemoveKey' ? delete BodyOfRequest.target : BodyOfRequest.target = SLOTarget ;
    * def SetSLOTimeWindow = SLOTimeWindow == 'RemoveKey' ? delete BodyOfRequest.timeWindow : BodyOfRequest.timeWindow = SLOTimeWindow ;
    * def SetCalenderPeriod = BodyOfRequest.calendarPeriod == "RemoveKey" ?  delete BodyOfRequest.calendarPeriod  :  BodyOfRequest.calendarPeriod = calendarPeriod ;
    * def SetCalenderTimeWindow = BodyOfRequest.windowType == "Rolling" ?  BodyOfRequest.timeWindow = SLOTimeWindow :  BodyOfRequest.timeWindow = null ;
    * def SetCalendarPeriod = BodyOfRequest.windowType == "Calendar" ?  BodyOfRequest.calendarPeriod =  calendarPeriod :  BodyOfRequest.calendarPeriod = null ;
    When request BodyOfRequest
    * print BodyOfRequest
    And method put
    * print response
    Then match response.message == expectedUpdateMessage

  @UpdateSloWithAlert
  Scenario: Update SLO with Alert Details
    Given path '/hcapobserve/slo/'
    And def BodyOfRequest = read("SLOManagement/testDataRequestJsons/updateSLORequestBody.json")
    * def GetApplicationService = call read('CustomerManagement/GetCustomer.feature@GetAllServicesForMonitoringSystem') { customerId : '#(CustomerId)' ,monitoringSystemId : '#(MonitoringSystemsId)' }
    * print GetApplicationService.response
    * def ApplicationService = GetApplicationService.response[0]
    * print SLOType
    And set BodyOfRequest.applicationService = ApplicationService
    And set BodyOfRequest.customerId = CustomerId
    And set BodyOfRequest.monitoringSystemId = MonitoringSystemsId
    And set BodyOfRequest.name = SLOName
    And set BodyOfRequest.id = SloId
    And set BodyOfRequest.sloType = SLOType
    And set BodyOfRequest.target = target
    And set BodyOfRequest.windowType = windowType
    And set BodyOfRequest.critical = Critical
    And set BodyOfRequest.high = High
    And set BodyOfRequest.medium = Medium
    And set BodyOfRequest.sloAlerts[0].alertName = alertName
    And set BodyOfRequest.sloAlerts[0].errorBudgetThreshold = updateErrorBudgetThreshold
    And set BodyOfRequest.sloAlerts[0].selectedAlertTools[0] = UpdatedAlertToolsId
    * def SetCalenderTimeWindow = BodyOfRequest.windowType == "Rolling" ?  BodyOfRequest.timeWindow = timeWindow :  BodyOfRequest.timeWindow = null ;
    * def SetCalendarPeriod = BodyOfRequest.windowType == "Calendar" ?  BodyOfRequest.calendarPeriod =  calendarPeriod :  BodyOfRequest.calendarPeriod = null ;
    * eval if ( BodyOfRequest.sloType == "Latency" )  BodyOfRequest.inputs[0].name = "duration" ;
    * eval if ( BodyOfRequest.sloType == "Latency" )  BodyOfRequest.inputs[0].value = Duration ;
    * eval if ( BodyOfRequest.sloType == "Latency" )  BodyOfRequest.inputs[1].name = "timeunit" ;
    * eval if ( BodyOfRequest.sloType == "Latency" )  BodyOfRequest.inputs[1].value = Timeunit ;
    When request BodyOfRequest
    * print BodyOfRequest
    And method put
    * print response
    Then match responseStatus == expectedStatus
    Then match response.sloAlerts[0].alertName == alertName
    Then match response.sloAlerts[0].errorBudgetThreshold == updateErrorBudgetThreshold
    Then match response.sloAlerts[0].selectedAlertTools[0] == UpdatedAlertToolsId