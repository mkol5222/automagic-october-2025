
output "rg" {
  value = local.rg
}

output "location" {
  value = local.location
}

output "vnet_name" {
  value = local.vnet_name
}

output "name" {
  value = local.cluster_name
}


output "linux_ip" {
    value       = module.linux.linux_ip
    description = "Linux VM Public IP"
}

output "flowlogs_sa" {
    value       = module.flowlogs.sa
    description = "Flowlogs Storage Account Name"
}