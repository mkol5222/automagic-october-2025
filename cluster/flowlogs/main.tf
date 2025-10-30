resource "azurerm_resource_group" "flowlogs" {
  name     = "automagic-cluster-flowlogs-${var.envId}"
  location = var.cluster_location
}

# resource "azurerm_network_security_group" "test" {
#   name                = "acctestnsg"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
# }

resource "azurerm_network_watcher" "flowlogs" {
  name                = "watcher-flowlogs-${var.envId}"
  location            = azurerm_resource_group.flowlogs.location
  resource_group_name = azurerm_resource_group.flowlogs.name
}

resource "azurerm_storage_account" "flowlogs" {
  name                = "watcher-flowlogs-${var.envId}"
  resource_group_name = azurerm_resource_group.flowlogs.name
  location            = azurerm_resource_group.flowlogs.location

  account_tier               = "Standard"
  account_kind               = "StorageV2"
  account_replication_type   = "LRS"
  # https_traffic_only_enabled = true
}

# resource "azurerm_log_analytics_workspace" "test" {
#   name                = "acctestlaw"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   sku                 = "PerGB2018"
# }

resource "azurerm_network_watcher_flow_log" "flowlogs" {
  network_watcher_name = azurerm_network_watcher.flowlogs.name
  resource_group_name  = azurerm_resource_group.flowlogs.name
  name                 = "watcher-flowlogs-${var.envId}"

  target_resource_id   = var.cluster_vnet_id
  storage_account_id = azurerm_storage_account.flowlogs.id
  enabled            = true

  retention_policy {
    enabled = true
    days    = 7
  }
}