resource "shoreline_notebook" "azure_web_app_resource_exhaustion_issue" {
  name       = "azure_web_app_resource_exhaustion_issue"
  data       = file("${path.module}/data/azure_web_app_resource_exhaustion_issue.json")
  depends_on = [shoreline_action.invoke_create_app_insights_web_app,shoreline_action.invoke_scale_up_app_service_plan]
}

resource "shoreline_file" "create_app_insights_web_app" {
  name             = "create_app_insights_web_app"
  input_file       = "${path.module}/data/create_app_insights_web_app.sh"
  md5              = filemd5("${path.module}/data/create_app_insights_web_app.sh")
  description      = "Create and Connect Application Insights for the web app"
  destination_path = "/tmp/create_app_insights_web_app.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "scale_up_app_service_plan" {
  name             = "scale_up_app_service_plan"
  input_file       = "${path.module}/data/scale_up_app_service_plan.sh"
  md5              = filemd5("${path.module}/data/scale_up_app_service_plan.sh")
  description      = "Scale up the App Service plan to a higher SKU: This involves increasing the resources allocated to the web app, such as CPU and memory. This can be done through the Azure Portal or programmatically using Azure CLI or Azure PowerShell."
  destination_path = "/tmp/scale_up_app_service_plan.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_create_app_insights_web_app" {
  name        = "invoke_create_app_insights_web_app"
  description = "Create and Connect Application Insights for the web app"
  command     = "`chmod +x /tmp/create_app_insights_web_app.sh && /tmp/create_app_insights_web_app.sh`"
  params      = ["APP_INSIGHTS_NAME","LOCATION","WEB_APP_NAME","RESOURCE_GROUP_NAME"]
  file_deps   = ["create_app_insights_web_app"]
  enabled     = true
  depends_on  = [shoreline_file.create_app_insights_web_app]
}

resource "shoreline_action" "invoke_scale_up_app_service_plan" {
  name        = "invoke_scale_up_app_service_plan"
  description = "Scale up the App Service plan to a higher SKU: This involves increasing the resources allocated to the web app, such as CPU and memory. This can be done through the Azure Portal or programmatically using Azure CLI or Azure PowerShell."
  command     = "`chmod +x /tmp/scale_up_app_service_plan.sh && /tmp/scale_up_app_service_plan.sh`"
  params      = ["NEW_SKU_NAME","WEB_APP_NAME","RESOURCE_GROUP_NAME","APP_SERVICE_PLAN_NAME"]
  file_deps   = ["scale_up_app_service_plan"]
  enabled     = true
  depends_on  = [shoreline_file.scale_up_app_service_plan]
}

