#!/bin/bash

set -euo pipefail

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


dotenvx run -f ../.env -fk ../.env.keys -- terraform destroy -auto-approve