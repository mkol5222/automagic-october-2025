data "azurerm_virtual_network" "vmss_vnet" {
  name                = var.vmss_vnet
  resource_group_name = var.vmss_rg
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vmss_vnet.id
}

resource "azurerm_subnet" "example" {
  name                 = "linux-subnet"
  resource_group_name  = data.azurerm_virtual_network.vmss_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vmss_vnet.name
  address_prefixes     = ["10.101.200.0/24"]

}