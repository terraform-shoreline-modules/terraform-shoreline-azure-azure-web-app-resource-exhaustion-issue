

#!/bin/bash



# Set variables

RESOURCE_GROUP=${RESOURCE_GROUP_NAME}

WEB_APP_NAME=${WEB_APP_NAME}

APP_INSIGHTS_NAME=${APP_INSIGHTS_NAME}

LOCATION=${LOCATION}



# Create Application Insights

az monitor app-insights component create --app $APP_INSIGHTS_NAME \ 

    --resource-group $RESOURCE_GROUP \

    --location $LOCATION



# Connect Application Insights to the Web App

az monitor app-insights component connect-webapp --resource-group $RESOURCE_GROUP \

 --app $APP_INSIGHTS_NAME \

 --web-app $WEB_APP_NAME --enable-profiler --enable-snapshot-debugger



# Verify connection

az webapp config appsettings list \

    --resource-group $RESOURCE_GROUP \

    --name $WEB_APP_NAME \

    --query "[?name=='APPLICATIONINSIGHTS_CONNECTION_STRING']"