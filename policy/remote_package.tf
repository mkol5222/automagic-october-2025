module "remote_package" {

depends_on = [ checkpoint_management_host.myip ]

  source = "./remote"

  envId          = var.envId
  appId          = var.appId
  password       = var.password
  tenant         = var.tenant
  subscriptionId = var.subscriptionId
}