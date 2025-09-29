resource "checkpoint_management_package" "cluster" {
  name              = "Cluster"
  comments          = "Policy for Cluster"
  color             = "orange"
  threat_prevention = true
  access            = true
}