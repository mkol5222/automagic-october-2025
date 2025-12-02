variable "location" {
  description = "VNET lovation"
  type        = string
}

variable "rg" {
    description = "VNET RG"
    type        = string
}

variable "name" {
    description = "Name of the virtual network"
    type        = string
}

# variable "envId" {
#   description = "Environment ID"
#   type        = string
# }

variable "subscriptionId" {
  description = "The Subscription ID which should be used."
  type        = string
}

variable "cidr" {
  description = "CIDR for VMET e.g. 10.100.0.0/16"
}

variable "subnet_name" {
  type = string
}


variable "subnet_cidr" {
  type = string
}

# variable "fw_enabled" {
#   description = "Enable Route via Firewall"
#   type        = bool
#   default     = false
# }

# variable "myip" {
#     description = "Your public IP address for management access."
#     type        = string
# }
