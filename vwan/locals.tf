locals {
    envId = var.envId
    rg =  "automagic-vwan-${local.envId}"
    location = "northeurope"
    # mgmt_name = "cpman-${local.envId}"
    # vnet_name = "automagic-management-vnet-${local.envId}"
    # vnet_address = "10.0.0.0/16"
    # management_subnet = "10.0.1.0/24"
    # vm_size = "Standard_D3_v2"
    # admin_password =  random_password.admin_password.result
}
