output "rg" {
  value = local.rg
}

output "name" {
  value = local.vmss_name
}

output "vmss_name" {
  value = local.vmss_name
}

output "location" {
  value = local.location
}

output "admin_password" {
  value = var.VMSS_ADMIN_PASSWORD
  sensitive = true
}