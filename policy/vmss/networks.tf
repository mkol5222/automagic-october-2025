resource "checkpoint_management_network" "vmss_vnet" {
  name         = "net_vmss_vnet"
  subnet4      = "10.101.0.0"
  mask_length4 = 16
  # nat-settings: 
  # auto-rule: true
  # hide-behind: "gateway"
  # install-on: "All"
  # method: "hide"
  nat_settings = {
    auto_rule    = true
    hide_behind  = "gateway"
    install_on   = "All"
    method       = "hide"
  }
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
