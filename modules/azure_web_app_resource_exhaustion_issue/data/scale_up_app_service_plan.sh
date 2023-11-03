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