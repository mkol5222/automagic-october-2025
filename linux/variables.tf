variable "vmss_location" {
  description = "Location of VMSS resources."
  type        = string
}

variable "vmss_rg" {
    description = "Resource group of VMSS resources."
    type        = string
}

variable "vmss_vnet" {
    description = "Name of the virtual network for VMSS."
    type        = string
}

variable "envId" {
  description = "Environment ID"
  type        = string
}

variable "subscriptionId" {
  description = "The Subscription ID which should be used."
  type        = string
}