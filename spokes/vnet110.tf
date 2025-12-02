
locals {
  rg110 = "automagic-vnet110-${var.envId}"
  vnet110 = "vnet110"
}

module "vnet110" {
  source = "../modvnet"

  providers = {
    azurerm = azurerm
  }

  rg             = "automagic-vnet110-${var.envId}"
  location       = "NorthEurope"
  name           = "vnet110"
  cidr           = "10.110.0.0/16"
  subnet_name    = "linux"
  subnet_cidr    = "10.110.0.0/24"
  subscriptionId = var.subscriptionId
}

module "linux110" {
    depends_on = [ module.vnet110 ]
    source = "../modlinux"
    providers = {
        azurerm = azurerm
    }
    rg = local.rg110
    vm_name = "linux110"
    vnet_name = local.vnet110
    subscriptionId = var.subscriptionId

    subnet_id = module.vnet110.first_subnet_id
}