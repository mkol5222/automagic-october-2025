module "linux" {
  depends_on = [module.example_module] # wait for cluster to be created

  source           = "./linux"
  cluster_vnet     = local.vnet_name
  cluster_rg       = local.rg
  cluster_location = local.location
  envId            = local.envId
  myip             = local.myip

}