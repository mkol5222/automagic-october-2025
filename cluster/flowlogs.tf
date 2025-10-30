module "flowlogs" {
  depends_on = [module.example_module] # wait for cluster to be created

  source           = "./flowlogs"
  cluster_vnet     = local.vnet_name
  cluster_rg       = local.rg
  cluster_location = local.location
  envId            = local.envId

  cluster_vnet_id  = data.azurerm_virtual_network.vnet.id
  # myip             = local.myip

  # fw_enabled = var.fw_enabled
}

data "azurerm_virtual_network" "vnet" {
   depends_on = [module.example_module]
  name                = local.vnet_name
  resource_group_name = local.rg
}