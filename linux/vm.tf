resource "azurerm_resource_group" "linux" {
  name     = local.linux_rg_name
  location = local.linux_location
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                  = local.vm_name
  location              = azurerm_resource_group.linux.location
  resource_group_name   = azurerm_resource_group.linux.name
  network_interface_ids = [azurerm_network_interface.nic.id]

  size = local.vm_size

  os_disk {
    name                 = "${local.vm_name}-myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name                   = local.vm_name
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = local.ssh_public_key
  }

  custom_data = base64encode(<<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - nginx
    runcmd:
      - systemctl enable nginx
      - systemctl start nginx
      - echo "<h1>Welcome to nginx on $(hostname)</h1>" > /var/www/html/index.html
  EOF
  )

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

  tags = {
    app = "linux1"
  }

}