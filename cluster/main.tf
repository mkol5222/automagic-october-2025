
locals {
    location = "northeurope"
    tenant = var.tenant
    subscriptionId = var.subscriptionId
    envId = var.envId
    rg = "automagic-cluster-${local.envId}"
    cluster_name = "ha-${local.envId}-"
    vnet_name = "cluster-vnet-${local.envId}"
    vnet_cidr = "10.69.0.0/16"
    subnet_cidr = ["10.69.1.0/24", "10.69.2.0/24"]
    vm_size = "Standard_D4ds_v5"
}