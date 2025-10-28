variable "envId" {
  description = "Environment ID"
  type        = string
}

variable "subscriptionId" {
  description = "The Subscription ID which should be used."
  type        = string
}

variable "appId" {
  description = "The Application (Client) ID which should be used."
  type        = string
  sensitive   = true
}

variable "password" {
  description = "The Application (Client) Secret which should be used."
  type        = string
  sensitive   = true
}

variable "tenant" {
  description = "The Tenant ID which should be used."
  type        = string
  sensitive   = false
}