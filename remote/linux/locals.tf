
locals {
    envId       = var.envId
    vm_name    = "automagic-remote-${local.envId}"
    linux_rg_name    = "automagic-remotelinux-${local.envId}"
    linux_location = var.cluster_location
    vm_size    = "Standard_B2s" // "Standard_DS1_v2"
    linux_subnet_cidr = "10.200.200.0/24"
}