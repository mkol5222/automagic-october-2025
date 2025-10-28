
# read ssh key from ~/.ssh/id_rsa.pub
locals {
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

output "ssh_public_key" {
  value       = local.ssh_public_key
  sensitive   = true
  description = "SSH Public Key"
  depends_on  = []
}
