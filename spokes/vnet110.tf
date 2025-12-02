module "vnet110" {
    source = "../modvnet"
    rg = "automagic-vnet110-${var.envId}"
    location = "NorthEurope"
    name = "vnet110"
    cidr = "10.110.0.0/16"
    subnet_name = "linux"
    subnet_cidr = "10.110.0.0/24"
    subscriptionId = var.subscriptionId
}