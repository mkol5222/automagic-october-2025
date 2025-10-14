resource "checkpoint_management_network_feed" "vmss_feedME" {
  name     = "feed_dev_cicd-jenkins"
  feed_url = "https://feed-serv.deno.dev/ip"
  #   username = "feed_username"
  #   password = "feed_password"
  feed_format     = "JSON"
  feed_type       = "IP Address"
  update_interval = 60
  json_query      = ".[]|.ip"
}

// https://quic.cloud/ips

resource "checkpoint_management_network_feed" "vmss_quiccloud" {
  name     = "vmss_quic_cloud"
  feed_url = "https://quic.cloud/ips?ln"
  #   username = "feed_username"
  #   password = "feed_password"
  feed_format     = "Flat List"
  feed_type       = "IP Address"
  update_interval = 60
}