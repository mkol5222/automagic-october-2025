variable "envId" {
  description = "Environment ID"
  type        = string
}

variable "subscriptionId" {
  description = "The Subscription ID which should be used."
  type        = string
}

variable "VMSS_ADMIN_PASSWORD" {
  description = "The admin password for the VMSS instances."
  type        = string
  sensitive   = true
}

variable "VMSS_SIC_KEY" {
  description = "The SIC key for the VMSS instances."
  type        = string
  sensitive   = true
}

// "Standard_D4ds_v5" vm_size
variable "vm_size" {
  description = "The size of the VMSS instances."
  type        = string
  default     = "Standard_D4ds_v5"
}

// management_IP
variable "MANAGEMENT_IP" {
  description = "The public IP address for management access."
  type        = string
}