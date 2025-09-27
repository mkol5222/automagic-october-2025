resource "checkpoint_management_network" "vmss_vnet" {
  name         = "net_vmss_vnet"
  subnet4      = "10.101.0.0"
  mask_length4 = 16
}

resource "checkpoint_management_network" "vmss_subnet_frontend" {
  name         = "net_vmss_subnet_frontend"
  subnet4      = "10.101.1.0"
  mask_length4 = 24
}

resource "checkpoint_management_network" "vmss_subnet_backend" {
  name         = "net_vmss_subnet_backend"
  subnet4      = "10.101.2.0"
  mask_length4 = 24
}
