resource "azapi_resource" "vnet_flow_log" {
  type      = "Microsoft.Network/networkWatchers/flowLogs@2023-09-01"
  name      = "vnet-flowlog-example"
  parent_id = data.azurerm_network_watcher.watcher.id

  body = {
    location = data.azurerm_network_watcher.watcher.location
    properties = {
      enabled           = true
      format            = { type = "JSON", version = 2 }
      # flowAnalyticsConfiguration = {
      #   networkWatcherFlowAnalyticsConfiguration = {
      #     enabled               = true
      #     workspaceId           = "cb77f5a8-384f-4e7f-b77f-3a50ea27e20e" //azurerm_log_analytics_workspace.example.workspace_id
      #     workspaceRegion       = "West Europe" // azurerm_log_analytics_workspace.example.location
      #     workspaceResourceId   = "/subscriptions/f4ad5e85-ec75-4321-8854-ed7eb611f61d/resourcegroups/my-aca-rg/providers/microsoft.operationalinsights/workspaces/workspace-myacargmfba" // azurerm_log_analytics_workspace.example.id
      #   }
      # }
      targetResourceId = var.cluster_vnet_id
      storageId        = azurerm_storage_account.flowlogs.id
      
    }
  }
}
