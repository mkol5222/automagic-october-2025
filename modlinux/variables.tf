variable "subscriptionId" {
  description = "The Subscription ID which should be used."
  type        = string
}

variable "rg" {
    description = "VNET RG"
    type        = string
}

variable "vnet_name" {
    description = "Name of the virtual network"
    type        = string
}

variable "vm_name" {
    type = string
}

// vm_size    = "Standard_B2s" // "Standard_DS1_v2"
variable "vm_size" {
    default = "Standard_B2s"
    type = string
  
}

variable "subnet_id" {
  description = "ID of the subnet to use for the VM"
  type        = string
}

// fw_enabled
variable "fw_enabled" {
  description = "Enable Route via Firewall"
  type        = bool
  default     = false
}

variable "firewall_ip" {
  description = "IP of the Firewall"
  type        = string
  default     = "192.168.1.1"
}

variable "myip" {
    description = "Your public IP address for management access."
    type        = string
  
}