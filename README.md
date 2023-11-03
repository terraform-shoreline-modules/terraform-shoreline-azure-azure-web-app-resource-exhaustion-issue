
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Web App Resource Exhaustion Issue
---

The Azure Web App Resource Exhaustion Issue occurs when a web app exhausts its allocated resources (CPU, memory, etc.), leading to performance issues. This can be resolved by either scaling up the App Service plan to a higher SKU or identifying performance bottlenecks using application insights and optimizing the code.

### Parameters
```shell
export RESOURCE_GROUP_NAME="PLACEHOLDER"

export APP_SERVICE_PLAN_NAME="PLACEHOLDER"

export APP_SERVICE_PLAN_ID="PLACEHOLDER"

export WEB_APP_NAME="PLACEHOLDER"

export NEW_SKU_NAME="PLACEHOLDER"

export APP_INSIGHTS_NAME="PLACEHOLDER"

export APP_INSIGHTS_ID="PLACEHOLDER"

export LOCATION="PLACEHOLDER"
```

## Debug

### Get the details of the affected web app
```shell
az webapp show --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### Get the current App Service plan SKU
```shell
az appservice plan show --resource-group ${RESOURCE_GROUP_NAME} --name ${APP_SERVICE_PLAN_NAME} --query "sku.name"
```

### Get performance metrics for the web app
```shell
az monitor metrics list --resource ${APP_SERVICE_PLAN_ID} --metric "CpuPercentage" "MemoryPercentage" --interval 5m
```

### Check Application Insights is configured for the web app
```shell
az webapp config appsettings list --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME} | grep -i applicationinsights
```

### Identify performance bottlenecks using Application Insights
```shell
az monitor app-insights query --apps ${APP_INSIGHTS_ID} --analytics-query "requests | summarize count(), avg(duration) by operation_Name"
```

### Create and Connect Application Insights for the web app
```shell


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


```

## Repair

### Scale up the App Service plan to a higher SKU: This involves increasing the resources allocated to the web app, such as CPU and memory. This can be done through the Azure Portal or programmatically using Azure CLI or Azure PowerShell.
```shell
bash

#!/bin/bash



# Set variables

RESOURCE_GROUP=${RESOURCE_GROUP_NAME}

WEB_APP_NAME=${WEB_APP_NAME}

PLAN_NAME=${APP_SERVICE_PLAN_NAME}

NEW_SKU=${NEW_SKU_NAME}



# Scale up the App Service plan to a higher SKU

az appservice plan update --name $PLAN_NAME --resource-group $RESOURCE_GROUP --sku $NEW_SKU



echo "App Service Plan $PLAN_NAME has been scaled up to $NEW_SKU for $WEB_APP_NAME web app."


```