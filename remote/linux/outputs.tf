output "linux_ip" {
    value       = azurerm_public_ip.public_ip.ip_address
    description = "Linux VM Public IP"
}