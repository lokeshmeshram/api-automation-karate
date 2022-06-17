@ignore
Feature: Delete Customer

  Background:
    * def apiBaseURL = apiBaseURL
    * def pwd = testUserPwd
    * def token = userName + ":" + pwd
    Given url apiBaseURL
    Given header Authorization = token

  @DeleteCustomer
  Scenario: Delete customer
    Given path '/hcapobserve/customer/'+CustomerId
    And header Authorization = token
    When method delete
    #  pass test if customer deleted successfully
    * print response
    Then match responseStatus == expectedStatus
    * def allCustomersAfterDelete = call read('CustomerManagement/GetCustomer.feature@getAllCustomer')
    * print allCustomersAfterDelete.response
    * def items = allCustomersAfterDelete.response
    * def ids = $items[*].id
    * print ids
    And match ids !contains CustomerId


  @DeleteCustomerWhichNotExist
  Scenario: Delete Customer which not exist
    Given path '/hcapobserve/customer/-123'
    And header Authorization = token
    When method delete
    Then match responseStatus == 404
    Then match response.message == 'Customer with id: -123 does not exist'