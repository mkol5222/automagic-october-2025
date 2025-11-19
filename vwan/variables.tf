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

// appId and passwoerd for service principal
variable "appId" {
  description = "The Client ID which should be used."
  type        = string
}
variable "password" {
  description = "The Client Secret which should be used."
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  type = string
}

variable "vwan_sic_key" {
  type = string
  sensitive = true
}