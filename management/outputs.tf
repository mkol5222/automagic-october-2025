# rg, name, admin_password
output "rg" {
    value = local.rg
}
output "name" {
    value = local.mgmt_name
}
output "admin_password" {
    value = local.admin_password
    sensitive = true
}