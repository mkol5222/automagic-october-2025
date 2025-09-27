
module "vmss" {

    source  = "CheckPointSW/cloudguard-network-security/azure//modules/vmss_new_vnet"
    version = "1.0.4"

    subscription_id                 = var.subscriptionId
    source_image_vhd_uri            = "noCustomUri"
    resource_group_name             = local.rg
    location                        = local.location
    vmss_name                       = local.vmss_name
    vnet_name                       = local.vnet_name
    address_space                   = local.vnet_address
    subnet_prefixes                 = local.subnet_prefixes
    backend_lb_IP_address           = 4
    admin_password                  = var.VMSS_ADMIN_PASSWORD
    sic_key                         = var.VMSS_SIC_KEY
    vm_size                         = var.vm_size
    disk_size                       = "100"
    vm_os_sku                       = "sg-byol"
    vm_os_offer                     = "check-point-cg-r82"
    os_version                      = "R82"
    bootstrap_script                = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
    allow_upload_download           = true
    authentication_type             = "Password"
    availability_zones_num          = "1"
    minimum_number_of_vm_instances  = 1
    maximum_number_of_vm_instances  = 2
    number_of_vm_instances          = 1
    management_name                 = "mgmt"
    management_IP                   = var.MANAGEMENT_IP
    management_interface            = "eth0-public"
    configuration_template_name     = "vmss_template"
    notification_email              = ""
    frontend_load_distribution      = "Default"
    backend_load_distribution       = "Default"
    enable_custom_metrics           = true
    enable_floating_ip              = false
    deployment_mode                 = "Standard"
    admin_shell                     = "/bin/bash"
    serial_console_password_hash    = ""
    maintenance_mode_password_hash  = ""
    nsg_id                          = ""
    add_storage_account_ip_rules    = false
    storage_account_additional_ips  = []
}