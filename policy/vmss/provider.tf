terraform {
  required_providers {
    checkpoint = {
      source = "CheckPointSW/checkpoint"
      version = "2.11.0"
    }
  }
}

provider "checkpoint" {
  # Configuration options
}