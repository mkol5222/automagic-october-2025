locals {
  rg120 = "automagic-vnet120-${var.envId}"
  vnet120 = "vnet120"
}
module "vnet120" {
    source = "../modvnet"
    providers = {
        azurerm = azurerm
    }
    rg = local.rg120
    location = "NorthEurope"
    name = local.vnet120
    cidr = "10.120.0.0/16"
    subnet_name = "linux"
    subnet_cidr = "10.120.0.0/24"
    subscriptionId = var.subscriptionId
}

module "linux120" {
    depends_on = [ module.vnet120 ]
    source = "../modlinux"
    providers = {
        azurerm = azurerm
    }
    rg = local.rg120
    vm_name = "linux120"
    vnet_name = local.vnet120
    subscriptionId = var.subscriptionId

    subnet_id = module.vnet120.first_subnet_id

    myip = var.myip
}