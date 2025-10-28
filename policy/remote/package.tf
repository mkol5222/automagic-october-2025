resource "checkpoint_management_package" "cluster" {
  name              = "Remote"
  comments          = "Policy for Remote Cluster"
  color             = "red"
  threat_prevention = true
  access            = true
}