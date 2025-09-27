// random admin password
resource "random_password" "admin_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric  = true
  override_special = "!@#$%^&*()_+"
  keepers = {
    envId = local.envId # sticks for current environment
  }
}