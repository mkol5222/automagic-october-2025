resource "checkpoint_management_network" "remote_vnet" {
  name         = "net_remote_vnet"
  subnet4      = "10.200.0.0"
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