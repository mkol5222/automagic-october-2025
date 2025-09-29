
locals {
  layer_name = "${checkpoint_management_package.cluster.name} Network"
}

data "checkpoint_management_data_access_rule" "cleanup" {
  depends_on = [checkpoint_management_package.cluster]
  name       = "Cleanup rule"
  layer      = local.layer_name
}

####
#
# Cleanup section 
resource "checkpoint_management_access_section" "cleanup_section" {
  name     = "Cleanup"
  position = { above = data.checkpoint_management_data_access_rule.cleanup.id }
  layer    = local.layer_name
}

### My rules

resource "checkpoint_management_access_section" "my_rules" {
  name     = "My Rules"
  position = { above = checkpoint_management_access_section.cleanup_section.id }
  layer    = local.layer_name
}

# allow all traffic from VNETs
resource "checkpoint_management_access_rule" "vnet_egress" {
  name        = "VNETs egress"
  layer       = local.layer_name
  position    = { below = checkpoint_management_access_section.my_rules.id }
  source      = [checkpoint_management_network.cluster_vnet.id]
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

# allow SSH to nodes from my IP
resource "checkpoint_management_access_rule" "ssh_cluster_nodes" {
  name        = "cluster nodes management"
  layer       = local.layer_name
  position    = { above = checkpoint_management_access_rule.vnet_egress.id }
  source      = ["myip"]
  destination = ["ha1", "ha2"]
  service     = ["ssh_version_2"]
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