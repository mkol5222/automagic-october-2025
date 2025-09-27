module "vmss_package" {

depends_on = [ checkpoint_management_host.myip ]

  source = "./vmss"

  envId          = var.envId
  appId          = var.appId
  password       = var.password
  tenant         = var.tenant
  subscriptionId = var.subscriptionId
}