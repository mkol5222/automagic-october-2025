resource "checkpoint_management_azure_data_center_server" "azureDC" {
  name                  = "myAzure"
  authentication_method = "service-principal-authentication"
  directory_id          = var.tenant
  application_id        = var.appId
  application_key       = var.password

  ignore_warnings = true
}

