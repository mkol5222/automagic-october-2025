resource "azurerm_route_table" "appgw-rt" {


  name                = "appgw-rt"
  location            = azurerm_resource_group.appgw.location
  resource_group_name = azurerm_resource_group.appgw.name
  #disable_bgp_route_propagation = false


# 10.69.200.4
  dynamic "route" {
    for_each = var.fw_enabled ? [1] : []
    content {
      name                   = "to-services-via-fw"
      address_prefix         = "10.69.200.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.69.2.4"
    }
  }


  route {
    name           = "route-to-my-pub-ip"
    address_prefix = "${var.myip}/32"
    next_hop_type  = "Internet"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_subnet_route_table_association" "appgw-rt-to-subnet" {
  subnet_id      = azurerm_subnet.appgw.id
  route_table_id = azurerm_route_table.appgw-rt.id
}