
locals {
    envId = var.envId
    rg =  "automagic-vmss-${local.envId}"
    location = "northeurope"
    vmss_name = "vmss-${local.envId}"
    vnet_name = "automagic-vmss-vnet-${local.envId}"
    vnet_address = "10.101.0.0/16"
    subnet_prefixes = ["10.101.1.0/24", "10.101.2.0/24"]
}