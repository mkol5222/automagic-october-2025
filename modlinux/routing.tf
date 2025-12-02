resource "azurerm_route_table" "linux-rt" {


  name                = "${var.vm_name}-rt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  # resource_group_name = azurerm_resource_group.linux.name
  #disable_bgp_route_propagation = false



  route {
    name           = "route-to-my-pub-ip"
    address_prefix = "${var.myip}/32"
    next_hop_type  = "Internet"
  }

  dynamic "route" {
    for_each = var.fw_enabled ? [1] : []
    content {
      name                   = "to-internet-via-fw"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.101.2.4"
    }
  }


  #   route {
  #     name           = "to-internet"
  #     address_prefix = "0.0.0.0/0"
  #     next_hop_type  = "Internet"
  #   }




  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_subnet_route_table_association" "linux-rt-to-subnet" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.linux-rt.id
}
