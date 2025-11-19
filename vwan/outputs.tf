output "vwan_sic_key" {
  value     = var.vwan_sic_key
  sensitive = true
}

output "vwan_rg" {
  value = local.rg
}

output "vwan_location" {
  value = local.location
}

    # vwan-name                       = "am-vwan"
    # vwan-hub-name                   = "am-vwan-hub"
output "vwan_name" {
    value = "am-vwan"
}
output "vwan_hub_name" {
    value = "am-vwan-hub"
}

