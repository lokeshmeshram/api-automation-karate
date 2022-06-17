@ignore
Feature: Create SLO

  Background:
    * def apiBaseURL = apiBaseURL
    * def pwd = testUserPwd
    * def token = userName + ":" + pwd
    Given url apiBaseURL
    Given header Authorization = token

  @CreateSlo
  Scenario: Create new SLO
    * def GetApplicationService = call read('CustomerManagement/GetCustomer.feature@GetAllServicesForMonitoringSystem') { customerId : '#(CustomerId)' ,monitoringSystemId : '#(MonitoringSystemsId)' }
    * print GetApplicationService.response
    * def ApplicationService = GetApplicationService.response[0]
    Given path '/hcapobserve/slo/'
    And def BodyOfRequest = read("SLOManagement/testDataRequestJsons/requestBody.json")
    And set BodyOfRequest.applicationService = ApplicationService
    And set BodyOfRequest.customerId = CustomerId
    And set BodyOfRequest.monitoringSystemId = MonitoringSystemsId
    And set BodyOfRequest.name = name
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
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    * print msg
    * def sloId = response.id
    * print sloId
    Then match msg == expectedMessage
    * def allSlos = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * print allSlos.response
    * def items = allSlos.response
    * def allSloId = $items[*].id
    * print allSloId
    And match allSloId contains sloId

  @CreateSLOWithoutMandatoryFields
  Scenario: Create SLO Without Mandatory Fields
    Given path '/hcapobserve/slo/'
    And def BodyOfRequest = { }
    * def SetSLOName = SLOName == 'RemoveKey' ? delete BodyOfRequest.name : BodyOfRequest.name = SLOName ;
    * def SetSLOCustomerId = CustomerId == 'RemoveKey' ? delete BodyOfRequest.customerId : BodyOfRequest.customerId = CustomerId ;
    * def SetSLOMonitoringSystemId = monitoringSystemId == 'RemoveKey' ? delete BodyOfRequest.monitoringSystemId : BodyOfRequest.monitoringSystemId = monitoringSystemId ;
    * def SetSLOApplicationService = SLOApplicationService == 'RemoveKey' ? delete BodyOfRequest.applicationService : BodyOfRequest.applicationService = SLOApplicationService ;
    * def SetSLOType = SLOType == 'RemoveKey' ? delete BodyOfRequest.sloType : BodyOfRequest.sloType = SLOType ;
    * def SetSLOWindowType = SLOWindowType == 'RemoveKey' ? delete BodyOfRequest.windowType : BodyOfRequest.windowType = SLOWindowType ;
    * def SetSLOCriticalThreshold = CriticalThreshold == 'RemoveKey' ? delete BodyOfRequest.critical : BodyOfRequest.critical = CriticalThreshold ;
    * def SetSLOHighThreshold = HighThreshold == 'RemoveKey' ? delete BodyOfRequest.high : BodyOfRequest.high = HighThreshold ;
    * def SetSLOMediumThreshold = MediumThreshold == 'RemoveKey' ? delete BodyOfRequest.medium : BodyOfRequest.medium = MediumThreshold ;
    * def SetSLOTarget = SLOTarget == 'RemoveKey' ? delete BodyOfRequest.target : BodyOfRequest.target = SLOTarget ;
    * def SetSLOTimeWindow = SLOTimeWindow == 'RemoveKey' ? delete BodyOfRequest.timeWindow : BodyOfRequest.timeWindow = SLOTimeWindow ;
    * def SetCalenderPeriod = calendarPeriod == "RemoveKey" ?  delete BodyOfRequest.calendarPeriod  :  BodyOfRequest.calendarPeriod = calendarPeriod ;
    When request BodyOfRequest
    * print BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedSLOResponseStatus
    * def msg = response.message
    * print msg
    Then match msg == expectedSLOResponseMessage

  @CreateSloWithSingleAlert
  Scenario: Create SLO with alert
    * def GetApplicationService = call read('CustomerManagement/GetCustomer.feature@GetAllServicesForMonitoringSystem') { customerId : '#(CustomerId)' ,monitoringSystemId : '#(MonitoringSystemsId)' }
    * def ApplicationService = GetApplicationService.response[0]
    Given path '/hcapobserve/slo/'
    And def BodyOfRequest = read("SLOManagement/testDataRequestJsons/requestBody.json")
    And set BodyOfRequest.applicationService = ApplicationService
    And set BodyOfRequest.customerId = CustomerId
    And set BodyOfRequest.monitoringSystemId = MonitoringSystemsId
    And set BodyOfRequest.name = SLOName
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
    And set BodyOfRequest.sloAlerts[0].alertName = alertName
    And set BodyOfRequest.sloAlerts[0].errorBudgetThreshold = errorBudgetThreshold
    And set BodyOfRequest.sloAlerts[0].selectedAlertTools[0] = selectedAlertToolsId
    When request BodyOfRequest
    * print BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    * print msg
    * def sloId = response.id
    * print sloId
    Then match msg == expectedMessage
    * def allSlos = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * print allSlos.response
    * def items = allSlos.response
    * def allSloId = $items[*].id
    * print allSloId
    And match allSloId contains sloId

  @CreateSloWithMultipleAlert
  Scenario: Create SLO with multiple alert
    * def GetApplicationService = call read('CustomerManagement/GetCustomer.feature@GetAllServicesForMonitoringSystem') { customerId : '#(CustomerId)' ,monitoringSystemId : '#(MonitoringSystemsId)' }
    * def ApplicationService = GetApplicationService.response[0]
    Given path '/hcapobserve/slo/'
    And def BodyOfRequest =  { "sloAlerts": [{"alertName": "","errorBudgetThreshold": 0,"selectedAlertTools": []},{"alertName": "","errorBudgetThreshold": 0,"selectedAlertTools": []}]}
    And set BodyOfRequest.applicationService = ApplicationService
    And set BodyOfRequest.customerId = CustomerId
    And set BodyOfRequest.monitoringSystemId = MonitoringSystemsId
    And set BodyOfRequest.name = SLOName
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
    And set BodyOfRequest.sloAlerts[0].alertName = alertName
    And set BodyOfRequest.sloAlerts[0].errorBudgetThreshold = errorBudgetThreshold
    And set BodyOfRequest.sloAlerts[0].selectedAlertTools[0] = selectedAlertToolsId
    And set BodyOfRequest.sloAlerts[1].alertName = updatedAlertName
    And set BodyOfRequest.sloAlerts[1].errorBudgetThreshold = updateErrorBudgetThreshold
    And set BodyOfRequest.sloAlerts[1].selectedAlertTools[0] = anotherSelectedAlertToolsId
    When request BodyOfRequest
    * print BodyOfRequest
    And method post
    * print response
    Then match responseStatus == expectedStatus
    * def msg = response.message
    * print msg
    * def sloId = response.id
    * print sloId
    Then match msg == expectedMessage
    * def allSlos = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * print allSlos.response
    * def items = allSlos.response
    * def allSloId = $items[*].id
    * print allSloId
    And match allSloId contains sloId
