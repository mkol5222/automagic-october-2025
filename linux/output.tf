output "rg" {
    value = azurerm_resource_group.linux.name
}

output "name" {
    value = local.vm_name
}

