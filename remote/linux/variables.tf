variable "cluster_location" {
  description = "Location of Cluster resources."
  type        = string
}

variable "cluster_rg" {
    description = "Resource group of Cluster resources."
    type        = string
}

variable "cluster_vnet" {
    description = "Name of the virtual network for Cluster."
    type        = string
}

variable "envId" {
  description = "Environment ID"
  type        = string
}

# variable "subscriptionId" {
#   description = "The Subscription ID which should be used."
#   type        = string
# }

variable "fw_enabled" {
  description = "Enable Route via Firewall"
  type        = bool
  default     = false
}

variable "myip" {
    description = "Your public IP address for management access."
    type        = string
}
