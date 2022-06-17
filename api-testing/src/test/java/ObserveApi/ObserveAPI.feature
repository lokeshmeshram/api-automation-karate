@Regression
Feature: Customer and SLO Management API

  Background:
    * configure cookies = null
    * def BaseURL = BaseURL
    * def token = adminRequestEntity
    * def adminRequestEntity = adminRequestEntity
    Given url BaseURL
    Given path 'login'
    And  print adminRequestEntity
    And request adminRequestEntity
    When method post
    * def ac_tk = responseHeaders.access-token
    * def rf_tk = responseHeaders.refresh-token
    * def tests = call read('TestData.feature')
    * configure afterFeature = function(){ karate.call('Hooks/afterFeature.feature'); }

  Scenario Outline: Valid test Create group and user - <testcase> <userName> <groupName>
#        * def createGroups = call read('Group/CreateGroup.feature')
    * def createUsers = call read('User/CreateUser.feature')
    Examples:
      | tests.userdata |

  Scenario Outline: Valid test create customer - <testcase> <Scenario>
#    * def createToken = call read('Hooks/GetTokens.feature') { userName : 'admin' , testUserPwd : '#(testUserPwd)' }
#    * header Cookie = createToken.responseCookies
#    * def createUsers = call read('User/CreateUser.feature')
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * print createToken.responseCookies
#    * configure headers = { 'access-token' : '#(createToken.responseCookies.access_token.value)' , refresh-token : '#(createToken.responseCookies.refresh_token.value)' }
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * configure cookies = null
    * print cookies
    Examples:
      | tests.customerdata |

  Scenario Outline: Valid test to create customer without Industry and Region - <testcase> <Scenario>
#    * def createUsers = call read('User/CreateUser.feature')
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithNameOnly')
    Examples:
      | tests.createcustomerwithonlyname |

  Scenario Outline: Valid api error when delete customer which does not exist - <testcase> <Scenario>
#    * def createUsers = call read('User/CreateUser.feature')
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def DeleteCustomer = call read('CustomerManagement/DeleteCustomer.feature@DeleteCustomerWhichNotExist')
    Examples:
      | tests.deletecustomer |

  Scenario Outline: Valid test Delete and Search customer - <testcase> <Scenario>
#    * def createUsers = call read('User/CreateUser.feature')
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * print createCustomer.response.id
    * def DeleteCustomer = call read('CustomerManagement/DeleteCustomer.feature@DeleteCustomer') { CustomerId : '#(createCustomer.response.id)' }
    Examples:
      | tests.DeleteCustomer |

  Scenario Outline: Valid test update customer - <testcase> <Scenario>
#    * def createUsers = call read('User/CreateUser.feature')
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * print createCustomer.response.id
    * def createCustomer = call read('CustomerManagement/UpdateCustomer.feature@UpdateCustomer') { CustomerId : '#(createCustomer.response.id)', MonitoringSystemsId : '#(createCustomer.response.monitoringSystems[0].id)' }
    Examples:
      | tests.updatecustomerdata |

  Scenario Outline: Validate modified values in Edit api response when another user edits customer - <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : 'admin' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * print createCustomer.response.id
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(UpdatedUserName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/UpdateCustomer.feature@ValidateUpdateCustomer') { CustomerId : '#(createCustomer.response.id)' }
    Examples:
      | tests.validateupdatecustomerdata |

  Scenario Outline: Valid Test to verify create api without Monitoring tool details - <testcase> <Scenario>
#    * def createUsers = call read('User/CreateUser.feature')
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithoutMonitoringSoftware')
    Examples:
      | tests.customerdatawithoutmonitoringtool |

  Scenario Outline: Valid test tp verify Edit api without Monitoring tool details - <testcase> <Scenario>
#    * def createUsers = call read('User/CreateUser.feature')
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * print createCustomer.response.id
    * def createCustomer = call read('CustomerManagement/UpdateCustomer.feature@UpdateCustomerWithoutMonitoringSoftware') { CustomerId : '#(createCustomer.response.id)' }
    Examples:
      | tests.updatecustomerdatawithoutmonitoringtool |

  Scenario Outline: Valid test to verify CRUD API for Customer with all valid details of multiple Monitoring tool - <testcase> <Scenario>
#    * def createUsers = call read('User/CreateUser.feature')
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithMultipleMonitoringTools')
    Examples:
      | tests.customerdataformultiplemonitoringtool |

  Scenario Outline: Valid test to verify create api without monitoring System Name
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithoutWithoutMandatoryFields') { monitoringSystemName : 'RemoveKey',expectedMessage : 'Monitoring system name cannot be null',expectedStatus : 400 }
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithoutWithoutMandatoryFields') { monitoringSystemName : 'c',expectedMessage : 'Monitoring system name input length must be greater than 3 characters',expectedStatus : 400 }
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithoutWithoutMandatoryFields') { monitoringSystemName : '%$#@',expectedMessage : 'Monitoring system name can contain alphanumeric, dot, underscore',expectedStatus : 400 }
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithoutWithoutMandatoryFields') { monitoringSystemName : ' ',expectedMessage : 'Monitoring system name cannot be blank',expectedStatus : 400 }
    Examples:
      | tests.validateupdatecustomerdata |

  Scenario Outline: Valid test to verify create api without Mandatory Fields <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithoutWithoutMandatoryFields')
    Examples:
      | tests.customerdatawithoutmandotoryfield |

  Scenario Outline: Valid test to verify Edit Customer api with MonitoringSystems
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * print createCustomer.response.id
    * def createCustomer = call read('CustomerManagement/UpdateCustomer.feature@UpdateCustomerWithMonitoringTool') { CustomerId : '#(createCustomer.response.id)', MonitoringSystemsId : '#(createCustomer.response.monitoringSystems[0].id)' }
    Examples:
      | tests.validateupdatecustomerdata |

  Scenario Outline:Valid test Create SLO - <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * print createCustomer.response.id
    * print createCustomer.response.monitoringSystems[0].id
    * def createSlo = call read('SLOManagement/CreateSlo.feature@CreateSlo') { CustomerId : '#(createCustomer.response.id)' ,MonitoringSystemsId : '#(createCustomer.response.monitoringSystems[0].id)' }
    Examples:
      | tests.createslodata |

  Scenario Outline:Verify API for getting SLO Violation History for a given SLO - <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * def items = GetAllSLOs.response
    * def allSloId = $items[*].id
    * print allSloId
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getSLoViolations') { sloId : '#(allSloId[0])'}
    Examples:
      | tests.getslodata |

  Scenario Outline:Verify API to get Error Budget Details for a given SLO - <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * def items = GetAllSLOs.response
    * def allSloId = $items[*].id
    * print allSloId
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getErrorBudgetDetails') { sloId : '#(allSloId[0])'}
    Examples:
      | tests.getslodata |

  Scenario Outline:Verify API for Failed v/s Successful Transactions for a given SLO - <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * def items = GetAllSLOs.response
    * def allSloId = $items[*].id
    * print allSloId
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getFailedAndSuccessfulTransactions') { sloId : '#(allSloId[allSloId.length-1])'}
    Examples:
      | tests.getslodata |

  Scenario Outline:  Valid test to Get Specific Customer details <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * print createCustomer.response.id
    * def getCustomerDetails = call read('CustomerManagement/GetCustomer.feature@getSpecificCustomer') { customerId : '#(createCustomer.response.id)' }
    Examples:
      | tests.getcustomerdata |

  Scenario Outline: Verify Create SLO without mandatory fields- <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def getAllCustomer = call read('CustomerManagement/GetCustomer.feature@getAllCustomer')
    * def items = getAllCustomer.response
    * def customerids = $items[*].id
    * def monitoringSystemsids = $items[*].monitoringSystems[0].id
    * print customerids
    * print monitoringSystemsids
    * def createSlo = call read('SLOManagement/CreateSlo.feature@CreateSLOWithoutMandatoryFields') { CustomerId : '#(customerids[0])', monitoringSystemId : '#(monitoringSystemsids[0])' }
    Examples:
      | tests.slodatawithoutmandotoryfield |

  Scenario Outline: Verify Create SLO without CustomerId and monitoringSystemId
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def getAllCustomer = call read('CustomerManagement/GetCustomer.feature@getAllCustomer')
    * def items = getAllCustomer.response
    * def customerids = $items[*].id
    * def monitoringSystemsids = $items[*].monitoringSystems[0].id
    * print customerids
    * print monitoringSystemsids
    * def createSlo = call read('SLOManagement/CreateSlo.feature@CreateSLOWithoutMandatoryFields') { CustomerId : 'RemoveKey', monitoringSystemId : '#(monitoringSystemsids[0])',expectedSLOResponseMessage : 'SLO customer should be specified',expectedSLOResponseStatus : 400 }
    * def createSlo = call read('SLOManagement/CreateSlo.feature@CreateSLOWithoutMandatoryFields') { CustomerId : '#(customerids[0])', monitoringSystemId : 'RemoveKey',expectedSLOResponseMessage : 'SLO Monitoring Tool should be specified',expectedSLOResponseStatus : 400 }
    Examples:
      | tests.getslodata |

  Scenario Outline:  Create Customer With Invalid Credentials
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithInvalidCredentials') { expectedMessage : 'Invalid Monitoring tool Credentials',expectedStatus : 403 }
    Examples:
      | tests.getcustomerdata |

  Scenario Outline:Verify API for get SLO details by ID
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * def items = GetAllSLOs.response
    * def allSloId = $items[*].id
    * print allSloId
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getSLOsByIds') { sloId : '#(allSloId[allSloId.length-1])'}
    Examples:
      | tests.getslodata |

  Scenario Outline:  Validate Monitoring tool Connection
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@ValidateMonitoringToolConnection') { expectedStatus : 200 }
    Examples:
      | tests.getcustomerdata |

  Scenario Outline:  Validate Get APIs of Customer
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def getCustomerDetails = call read('CustomerManagement/GetCustomer.feature@GetIndustryTypeValues')
    * def getCustomerDetails = call read('CustomerManagement/GetCustomer.feature@GetRegionValues')
    * def getCustomerDetails = call read('CustomerManagement/GetCustomer.feature@GetAllSupportedMonitoringToolsList')
    Examples:
      | tests.getcustomerdata |

  Scenario Outline:  Valid test to Get All Services For MonitoringSystem
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomer')
    * print createCustomer.response
    * def getCustomerDetails = call read('CustomerManagement/GetCustomer.feature@GetAllServicesForMonitoringSystem') { customerId : '#(createCustomer.response.id)' ,monitoringSystemId : '#(createCustomer.response.monitoringSystems[0].id)' }
    Examples:
      | tests.getcustomerdata |

  Scenario Outline: Valid test update SLO - <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * def items = GetAllSLOs.response
    * def allSloId = $items[*].id
    * def GetSpecificSLO = call read('SLOManagement/GetSLO.feature@getSLOsByIds') { sloId : '#(allSloId[allSloId.length-1])'}
    * def items = GetSpecificSLO.response
    * def sloids = $items[*].id
    * def custids = $items[*].customer.id
    * def monitoringsystemsids = $items[*].customer.monitoringSystems[0].id
    * def slotypee = $items[*].sloType
    * def SetSloType =  slotypee[0] == "Latency" ? SLOType = "Latency" : SLOType = "Availability" ;
    * print SetSloType
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
    * sleep(300000)
    * def UpdateSlo = call read('SLOManagement/UpdateSLO.feature@UpdateSlo') {SLOType : '#(SLOType)', SloId : '#(sloids[0])', CustomerId : '#(custids[0])' , MonitoringSystemsId : '#(monitoringsystemsids[0])'}
    * print UpdateSlo.response
    * def GetSloChangeHistory = call read('SLOManagement/GetSLO.feature@getslochangehistory') { sloId : '#(allSloId[allSloId.length-1])'}
    * print GetSloChangeHistory.response
    Examples:
      | tests.updateslodata |

  Scenario Outline: Valid test update SLO without mandatory fields data - <testcase> <Scenario>
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * def items = GetAllSLOs.response
    * def allSloId = $items[*].id
    * def GetSpecificSLO = call read('SLOManagement/GetSLO.feature@getSLOsByIds') { sloId : '#(allSloId[0])'}
    * print GetSpecificSLO.response
    * def items = GetSpecificSLO.response
    * def sloids = $items[*].id
    * def custids = $items[*].customer.id
    * def monitoringsystemsids = $items[*].customer.monitoringSystems[0].id
    * def GetApplicationService = call read('CustomerManagement/GetCustomer.feature@GetAllServicesForMonitoringSystem') { customerId : '#(custids[0])' ,monitoringSystemId : '#(monitoringsystemsids[0])' }
    * def slotypee = $items[*].sloType
    * print slotypee
    * def SetSloType =  slotypee[0] == "Latency" ? SLOType = "Latency" : SLOType = "Availability" ;
    * print SetSloType
    * def UpdateSlo = call read('SLOManagement/UpdateSLO.feature@UpdateSloInvalidData') {SLOType : '#(SLOType)', ApplicationService : '#(GetApplicationService.response[0])' ,SloId : '#(sloids[0])', CustomerId : '#(custids[0])' , MonitoringSystemsId : '#(monitoringsystemsids[0])'}
    * print UpdateSlo.response
    Examples:
      | tests.updatesloinvaliddata |

  Scenario Outline: Verify api of edit slo with invalid customer Id, Application Service and SLO Type
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * def items = GetAllSLOs.response
    * def allSloId = $items[*].id
    * def GetSpecificSLO = call read('SLOManagement/GetSLO.feature@getSLOsByIds') { sloId : '#(allSloId[0])'}
    * print GetSpecificSLO.response
    * def items = GetSpecificSLO.response
    * def sloids = $items[*].id
    * def custids = $items[*].customer.id
    * def monitoringsystemsids = $items[*].customer.monitoringSystems[0].id
    * def CustId = custids[0] + 2
    * def GetApplicationService = call read('CustomerManagement/GetCustomer.feature@GetAllServicesForMonitoringSystem') { customerId : '#(custids[0])' ,monitoringSystemId : '#(monitoringsystemsids[0])' }
    * def slotypee = $items[*].sloType
    * def SetSloType =  slotypee[0] == "Latency" ? SLOType = "Latency" : SLOType = "Availability" ;
    * def UpdateInvalidCustomerId = call read('SLOManagement/UpdateSLO.feature@UpdateSloInvalidData') { SLOType : '#(SLOType)',ApplicationService : '#(GetApplicationService.response[0])' , SloId : '#(sloids[0])', CustomerId : '#(CustId)' , MonitoringSystemsId : '#(monitoringsystemsids[0])',expectedUpdateMessage : 'Customer cannot be changed'}
    * def UpdateBlankCustomerId = call read('SLOManagement/UpdateSLO.feature@UpdateSloInvalidData') { SLOType : '#(SLOType)', ApplicationService : '#(GetApplicationService.response[0])' ,SloId : '#(sloids[0])', CustomerId : '' , MonitoringSystemsId : '#(monitoringsystemsids[0])',expectedUpdateMessage : 'SLO customer should be specified'}
    * def UpdateApplicationService = call read('SLOManagement/UpdateSLO.feature@UpdateSloInvalidData') { SLOType : '#(SLOType)',ApplicationService : 'abc' ,SloId : '#(sloids[0])', CustomerId : '#(custids[0])' , MonitoringSystemsId : '#(monitoringsystemsids[0])',,expectedUpdateMessage : 'Application service name cannot be changed'}
    * def SetSloTypee = slotypee[0] != "Latency" ? SLOType = "Latency" : SLOType = "Availability" ;
    * def UpdateSLOType = call read('SLOManagement/UpdateSLO.feature@UpdateSloInvalidData') {SLOType : '#(SLOType)', ApplicationService : '#(GetApplicationService.response[0])' ,SloId : '#(sloids[0])', CustomerId : '#(custids[0])' , MonitoringSystemsId : '#(monitoringsystemsids[0])',,expectedUpdateMessage : 'SLO type cannot be changed'}
    * print UpdateSLOType
    Examples:
      | tests.getslodata |

  Scenario Outline:Verify API for Performance trend details for a given SLO
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getAllSLO')
    * def items = GetAllSLOs.response
    * def allSloId = $items[*].id
    * print allSloId
    * def GetAllSLOs = call read('SLOManagement/GetSLO.feature@getSLOPerformanceTrendDetails') { sloId : '#(allSloId[allSloId.length-1])'}
    Examples:
      | tests.getslodata |

  Scenario Outline: Valid test of create customer with single alert
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
#    * def createUsers = call read('User/CreateUser.feature')
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithAlert') { customerName : "SingleAlertCustomer" }
    Examples:
      | tests.customerdataforalert |

  Scenario Outline: Valid test of create customer with multiple alert
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
#    * def createUsers = call read('User/CreateUser.feature')
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithMultipleAlert') { customerName : "MultipleAlertCustomer" }
    Examples:
      | tests.customerdataforalert |

  Scenario Outline: Valid test of Edit customer with alert details
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithAlert') { customerName : "AlertCustomer" }
    * def UpdateCustomer = call read('CustomerManagement/UpdateCustomer.feature@UpdateCustomerWithAlertDetails') { CustomerId : '#(createCustomer.response.id)', MonitoringSystemsId : '#(createCustomer.response.monitoringSystems[0].id)', customerName : "EditAlertCustomer", alertingToolGroups : '#(createCustomer.response.alertingToolGroups[0].id)'}
    Examples:
      | tests.customerdataforalert |

  Scenario Outline:Valid test of Create SLO with single alert
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithAlert')
    * def createSlo = call read('SLOManagement/CreateSlo.feature@CreateSloWithSingleAlert') { customerName : "SingleSloAlertCustomer", SLOName :"SingleAlertSLO", CustomerId : '#(createCustomer.response.id)' ,MonitoringSystemsId : '#(createCustomer.response.monitoringSystems[0].id)', selectedAlertToolsId : '#(createCustomer.response.alertingToolGroups[0].id)'}
    Examples:
      | tests.createslodatawithalert |

  Scenario Outline:Valid test of Create SLO with multiple alert
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithMultipleAlert')
    * def createSlo = call read('SLOManagement/CreateSlo.feature@CreateSloWithMultipleAlert') {customerName : "MultipleSLOAlertCustomer",SLOName :"MultipleAlertSLO", CustomerId : '#(createCustomer.response.id)' , MonitoringSystemsId : '#(createCustomer.response.monitoringSystems[0].id)', selectedAlertToolsId : '#(createCustomer.response.alertingToolGroups[0].id)', anotherSelectedAlertToolsId : '#(createCustomer.response.alertingToolGroups[1].id)'}
    Examples:
      | tests.createslodatawithalert |

  Scenario Outline:Valid test of Edit SLO with alert details
    * def createToken = call read('Hooks/GetTokens.feature') { userName : '#(userName)' , testUserPwd : '#(testUserPwd)' }
    * header Cookie = createToken.responseCookies
    * def createCustomer = call read('CustomerManagement/CreateCustomer.feature@CreateCustomerWithMultipleAlert')
    * def createSlo = call read('SLOManagement/CreateSlo.feature@CreateSloWithSingleAlert') { customerName : "SingleSloAlertCustomer", SLOName :"SingleAlertSLO", CustomerId : '#(createCustomer.response.id)' ,MonitoringSystemsId : '#(createCustomer.response.monitoringSystems[0].id)', selectedAlertToolsId : '#(createCustomer.response.alertingToolGroups[0].id)'}
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
    * sleep(306000)
    * def UpdateSlo = call read('SLOManagement/UpdateSLO.feature@UpdateSlo') {UpdatedAlertToolsId:'#(createCustomer.response.alertingToolGroups[1].id)', SloId : '#(createSlo.response.id)', CustomerId : '#(createCustomer.response.id)' , MonitoringSystemsId : '#(createCustomer.response.monitoringSystems[0].id)'}
    * print UpdateSlo.response
    Examples:
      | tests.createslodatawithalert |