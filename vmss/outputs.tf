output "rg" {
  value = local.rg
}

output "name" {
  value = local.vmss_name
}

output "vmss_name" {
  value = local.vmss_name
}

output "vnet_name" {
  value = local.vnet_name
}

output "location" {
  value = local.location
}

output "admin_password" {
  value = var.VMSS_ADMIN_PASSWORD
  sensitive = true
}

output "sic_key" {
  value     = var.VMSS_SIC_KEY
  sensitive = true
  
}