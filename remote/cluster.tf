

module "example_module" {

  source  = "CheckPointSW/cloudguard-network-security/azure//modules/high_availability_new_vnet"
  version = "1.0.4"

  tenant_id                      = local.tenant
  source_image_vhd_uri           = "noCustomUri"
  resource_group_name            = local.rg
  cluster_name                   = local.cluster_name
  location                       = local.location
  vnet_name                      = local.vnet_name
  address_space                  = local.vnet_cidr
  subnet_prefixes                = local.subnet_cidr
  admin_password                 = var.cluster_admin_password
  smart_1_cloud_token_a          = ""
  smart_1_cloud_token_b          = ""
  sic_key                        = var.cluster_sic_key
  vm_size                        = local.vm_size
  disk_size                      = "110"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r82"
  os_version                     = "R82"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  allow_upload_download          = true
  authentication_type            = "Password"
  availability_type              = "Availability Zone"
  enable_custom_metrics          = true
  enable_floating_ip             = false
  use_public_ip_prefix           = false
  create_public_ip_prefix        = false
  existing_public_ip_prefix_id   = ""
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  maintenance_mode_password_hash = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  nsg_id                         = ""
  add_storage_account_ip_rules   = false
  storage_account_additional_ips = []
}