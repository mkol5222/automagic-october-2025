resource "azurerm_resource_group" "linux" {
  name     = local.linux_rg_name
  location = local.linux_location
}