resource "checkpoint_management_network" "cluster_vnet" {
  name         = "net_cluster_vnet"
  subnet4      = "10.69.0.0"
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