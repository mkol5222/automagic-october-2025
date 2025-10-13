variable "envId" {
  description = "Environment ID"
  type        = string
}

variable "subscriptionId" {
  description = "The Subscription ID which should be used."
  type        = string
}

variable "tenant" {
  description = "The Tenant ID which should be used."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "vnet_rg" {
  description = "The Resource Group of the Virtual Network."
  type        = string
}

variable "appgw_subnet_cidr" {
    description = "The address to use for the Application Gateway subnet."
    type        = string
}