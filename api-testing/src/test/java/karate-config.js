function() {
  var config = {
      testUserPwd: 'Admin@1234',
  };
      karate.configure('ssl', true);
      config.BaseURL = java.lang.System.getenv('TEST_URL')
      config.apiBaseURL = java.lang.System.getenv('TEST_URL')+"api/"
      config.adminToken = java.lang.System.getenv('ADMINUSER')+":"+java.lang.System.getenv('ADMINPASSWORD');
      config.apiKey = java.lang.System.getenv('AZURE_APIKEY');
      config.applicationId = java.lang.System.getenv('AZURE_APPLICATIONID');
      config.updateApiKey = java.lang.System.getenv('UPDATE_AZURE_APIKEY') ;
      config.updateApplicationId  = java.lang.System.getenv('UPDATE_AZURE_APPLICATIONID');
      config.monitoringSystemName = java.lang.System.getenv('MONITORING_SYSTEM_NAME') ;
      config.adminRequestEntity = '{"username":"'+java.lang.System.getenv('ADMINUSER') +'","password":"' + java.lang.System.getenv('ADMINPASSWORD')+'"}'
      config.webhookURL = java.lang.System.getenv('WEBHOOK_URL');
      config.updateWebhookURL = java.lang.System.getenv('UPDATE_WEBHOOK_URL');
      return config;
}
