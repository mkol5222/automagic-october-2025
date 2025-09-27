#!/bin/bash

set -euo pipefail

# if ~/.ssh/id_rsa.pub does not exist, create key without passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

VMSS_VNET=$(cd ../vmss && terraform output -raw vnet_name)
VMSS_LOCATION=$(cd ../vmss && terraform output -raw location)
VMSS_RG=$(cd ../vmss && terraform output -raw rg)

export TF_VAR_vmss_vnet="$VMSS_VNET"
export TF_VAR_vmss_location="$VMSS_LOCATION"
export TF_VAR_vmss_rg="$VMSS_RG"

cat <<EOF
VMSS_VNET: $VMSS_VNET
VMSS_LOCATION: $VMSS_LOCATION
VMSS_RG: $VMSS_RG

EOF

MYIP=$(curl -s https://ipinfo.io/ip)
echo "My public IP is: $MYIP"
export TF_VAR_myip="$MYIP"


dotenvx run -f ../.env -fk ../.env.keys -- terraform init
dotenvx run -f ../.env -fk ../.env.keys -- terraform apply -auto-approve