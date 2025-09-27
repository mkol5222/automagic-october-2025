# Check Point Security Management Server in Azure with Terraform


See Check Point CloudGuard modules for Azure 
https://github.com/CheckPointSW/terraform-azure-cloudguard-network-security?tab=readme-ov-file#repository-structure

and how to use Security Management Server in a new VNet
https://registry.terraform.io/modules/CheckPointSW/cloudguard-network-security/azure/latest/submodules/management_new_vnet#usage

```bash
# deploy
make management-up
# open new terminal tab (split terminal)
make management-serial
# monitor progress until setup is complete (there is login prompt)

# 1st tab - wait for API server availability (only then SmartConsole can connect)
make management-api
# once wait is over, check IP and admin's password to login
make management-info