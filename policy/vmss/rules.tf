
locals {
  layer_name = "${checkpoint_management_package.vmss.name} Network"
}

data "checkpoint_management_data_access_rule" "data_access_rule" {
  depends_on = [checkpoint_management_package.vmss]
  name = "Cleanup rule"
  layer = local.layer_name
}

####
#
# Cleanup section 
resource "checkpoint_management_access_section" "cleanup_section" {
  name = "Cleanup"
  position = {above  = data.checkpoint_management_data_access_rule.data_access_rule.id}
   layer = local.layer_name
}

### VNETs egress section
resource "checkpoint_management_access_section" "vnet_egress_section" {
  name = "VNETs egress section"
  position = {above  = checkpoint_management_access_section.cleanup_section.id}
   layer = local.layer_name
}

# allow all traffic from VNETs
resource "checkpoint_management_access_rule" "vnet_egress" {
  name        = "VNETs egress"
  layer       = local.layer_name
  position    = { below = checkpoint_management_access_section.vnet_egress_section.id }
  source      = [checkpoint_management_network.vmss_vnet.id]
  destination = ["Any"]
  service     = ["Any"]
  content     = ["Any"]
  time        = ["Any"]
  install_on  = ["Policy Targets"]
  track = {
    type                    = "Log"
    accounting              = false
    alert                   = "none"
    enable_firewall_session = false
    per_connection          = true
    per_session             = false
  }
  action_settings = {}
  custom_fields   = {}
  vpn             = "Any"
  action          = "Accept"
}