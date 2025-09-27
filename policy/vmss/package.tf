resource "checkpoint_management_package" "vmss" {
  name              = "VMSS"
  comments          = "Policy for VMSS"
  color             = "blue"
  threat_prevention = true
  access            = true
}