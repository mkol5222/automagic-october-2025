
locals {
    envId       = var.envId
    vm_name    = "automagic-clinux-${local.envId}"
    linux_rg_name    = "automagic-clinux-${local.envId}"
    linux_location = var.cluster_location
    vm_size    = "Standard_B2s" // "Standard_DS1_v2"
}