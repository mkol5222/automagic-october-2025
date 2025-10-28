data "http" "myip" {
  url = "http://ip.iol.cz/ip/"
}


locals {
    myip = chomp(data.http.myip.response_body)
}

output "myip" {
  value = local.myip
}