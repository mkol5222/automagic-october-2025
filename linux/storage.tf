
resource "azurerm_storage_account" "storage" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.linux.location
  resource_group_name      = azurerm_resource_group.linux.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    # resource_group = data.azurerm_resource_group.rg.name
    vm_name = local.vm_name
  }

  byte_length = 8
}
