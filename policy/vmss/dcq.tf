resource "checkpoint_management_data_center_query" "allVMs" {

  name         = "VMs in Azure"
  data_centers = ["All"]
  query_rules {
    key_type = "predefined"
    key      = "type-in-data-center"
    values   = ["Virtual Machine"]
  }
}