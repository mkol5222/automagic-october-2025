
locals {
    envId       = var.envId
    vm_name    = "automagic-linux-${local.envId}"
    linux_rg_name    = "automagic-linux-${local.envId}"
    linux_location = var.vmss_location
    vm_size    = "Standard_B2s" // "Standard_DS1_v2"
}