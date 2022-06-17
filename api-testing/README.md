##### Steps to Execute in HCAP Test

###### **Pre-Script**

cd api-testing export TEST_URL='<>';

export ADMINUSER='admin';

export ADMINPASSWORD='<>';

export testUserPwd='<>';

export AZURE_APIKEY ='<>';

export AZURE_APPLICATIONID ='<>';

export UPDATE_AZURE_APIKEY ='<>';

export UPDATE_APPLICATIONID ='<>';

export MONITORING_SYSTEM_NAME="";

export WEBHOOK_URL="";

export UPDATE_WEBHOOK_URL="";

###### **Test RunCommand**

mvn clean install

###### **Report Location**

target/cucumber-html-reports
