
# vnet_address = "10.0.0.0/16"
# management_subnet = "10.0.1.0/24"

resource "checkpoint_management_network" "management_vnet" {
  name         = "net_management_vnet"
  subnet4      = "10.0.0.0"
  mask_length4 = 16
}

resource "checkpoint_management_network" "management_subnet" {
  name         = "net_management_subnet"
  subnet4      = "10.0.1.0"
  mask_length4 = 24
}