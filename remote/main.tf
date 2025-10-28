
locals {
  location       = "westeurope"
  tenant         = var.tenant
  subscriptionId = var.subscriptionId
  envId          = var.envId
  rg             = "automagic-remote-${local.envId}"
  cluster_name   = "ha"
  vnet_name      = "remote-vnet-${local.envId}"
  vnet_cidr      = "10.200.0.0/16"
  subnet_cidr    = ["10.200.1.0/24", "10.200.2.0/24"]
  vm_size        = "Standard_D4ds_v5"
}