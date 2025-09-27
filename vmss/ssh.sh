#!/bin/bash

set -euo pipefail

# if ~/.ssh/id_rsa.pub does not exist, create key without passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi



RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)
ADMIN_PASSWORD=$(terraform output -raw admin_password)


# VMSS instances Public IPs
az vmss list-instance-public-ips \
  --resource-group $RG \
  --name $NAME \
  -o table


cat <<EOF

VMSS deployment info:

Resource Group:   $RG
Name:             $NAME
Admin Username:   admin
Admin Password:   $ADMIN_PASSWORD
Management IP:    

EOF

# first arg or 0
INSTANCE=${1:-0}
echo "Connecting to instance $INSTANCE"
IP=$(az vmss list-instance-public-ips --resource-group "$RG" --name "$NAME" --query "[$INSTANCE].ipAddress" -o tsv)
echo "Instance $INSTANCE IP: $IP"

# remove first element of args, because it's the instance id
REST_OF_ARGS=("${@:2}")
# notice ability to pass commands with script args "$@"
ssh admin@"$IP" "${REST_OF_ARGS[@]}"