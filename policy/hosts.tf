
// check point management host for localhost 127.0.0.1
resource "checkpoint_management_host" "localhost" {
  name = "localhost"
  ipv4_address = "127.0.0.1"
}

# resource "checkpoint_management_host" "localhost_2" {
#   name = "localhost_2"
#   ipv4_address = "127.0.0.1"
# }