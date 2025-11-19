
module "vwan" {

    source  = "CheckPointSW/cloudguard-network-security/azure//modules/nva_into_new_vwan"
    version = "1.0.4"

    authentication_method           = "Service Principal"
    client_secret                   = var.password
    client_id                       = var.appId
    tenant_id                       = var.tenant
    subscription_id                 = var.subscriptionId
    resource-group-name             = local.rg
    location                        = local.location
    vwan-name                       = "am-vwan"
    vwan-hub-name                   = "am-vwan-hub"
    vwan-hub-address-prefix         = "10.0.0.0/16"
    managed-app-name                = "am-vwan-managed-app-nva"
    nva-rg-name                     = "automagic-vwan-nva-${local.envId}"
    nva-name                        = "am-vwan-nva"
    os-version                      = "R82"
    license-type                    = "Security Enforcement (NGTP)"
    scale-unit                      = "2"
    bootstrap-script                = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
    admin-shell                     = "/bin/bash"
    sic-key                         = var.vwan_sic_key
    admin_SSH_key                   = var.ssh_public_key
    bgp-asn                         = "64512"
    custom-metrics                  = "yes"
    routing-intent-internet-traffic = "no"
    routing-intent-private-traffic  = "no"
    smart1-cloud-token-a            = ""
    smart1-cloud-token-b            = ""
    smart1-cloud-token-c            = ""
    smart1-cloud-token-d            = ""
    smart1-cloud-token-e            = ""   
    existing-public-ip              = ""
    new-public-ip                   = "yes"
}

# module "role" {
#     source = "./role"

#     subscription_id = local.secrets.subscriptionId
#     tenant_id       = local.secrets.tenant
#     envId           = local.secrets.envId
#     nva-rg          = "automagic-vwan-nva-${local.secrets.envId}"
# }

# output "cme_client_id" {
#   value = module.role.client_id
# }
# output "cme_client_secret" {
#   value = module.role.client_secret
#   sensitive = true
# }