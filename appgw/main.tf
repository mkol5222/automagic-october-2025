locals {
  location       = "northeurope"
  tenant         = var.tenant
  subscriptionId = var.subscriptionId
  envId          = var.envId
  rg             = "automagic-appgw-${local.envId}"
}

resource "azurerm_resource_group" "appgw" {
  name     = local.rg
  location = local.location
}


data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

 resource "azurerm_subnet" "appgw" {
   name                 = "appgw-subnet"
   resource_group_name  = var.vnet_rg
   virtual_network_name = data.azurerm_virtual_network.vnet.name
   address_prefixes     = [var.appgw_subnet_cidr]
 }

# resource "azurerm_virtual_network" "example" {
#   name                = "example-network"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   address_space       = ["10.254.0.0/16"]
# }

# resource "azurerm_subnet" "example" {
#   name                 = "example"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.254.0.0/24"]
# }

resource "azurerm_public_ip" "appgw" {
  name                = "appgw-pip"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location
  allocation_method   = "Static"
}

# # since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${data.azurerm_virtual_network.vnet.name}-beap"
  frontend_port_name             = "${data.azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${data.azurerm_virtual_network.vnet.name}-feip"
  http_setting_name              = "${data.azurerm_virtual_network.vnet.name}-be-htst"
  listener_name                  = "${data.azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule_name      = "${data.azurerm_virtual_network.vnet.name}-rqrt"
  redirect_configuration_name    = "${data.azurerm_virtual_network.vnet.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "appgw-${local.envId}"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}