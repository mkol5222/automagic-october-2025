resource "azapi_resource" "vnet_flow_log" {
  type      = "Microsoft.Network/networkWatchers/flowLogs@2023-09-01"
  name      = "vnet-flowlog-example"
  parent_id = azurerm_network_watcher.flowlogs.id

  body = jsonencode({
    properties = {
      enabled           = true
      format            = { type = "JSON", version = 2 }
    #   flowAnalyticsConfiguration = {
    #     networkWatcherFlowAnalyticsConfiguration = {
    #       enabled               = true
    #       workspaceId           = azurerm_log_analytics_workspace.example.workspace_id
    #       workspaceRegion       = azurerm_log_analytics_workspace.example.location
    #       workspaceResourceId   = azurerm_log_analytics_workspace.example.id
    #     }
    #   }
      targetResourceId = var.cluster_vnet_id
      storageId        = azurerm_storage_account.flowlogs.id
    }
  })
}
