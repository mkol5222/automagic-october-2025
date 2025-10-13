#!/bin/bash

set -euo pipefail

export TF_VAR_appgw_subnet_cidr="10.69.7.0/24"

export TF_VAR_vnet_rg=$(cd ../cluster && terraform output -raw rg)
# vnet_name
export TF_VAR_vnet_name=$(cd ../cluster && terraform output -raw vnet_name)

export TF_VAR_myip=$(curl -s http://ip.iol.cz/ip/)
