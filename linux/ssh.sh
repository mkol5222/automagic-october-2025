#!/bin/bash

set -euo pipefail

# if ~/.ssh/id_rsa.pub does not exist, create key without passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi



RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)
# ADMIN_PASSWORD=$(terraform output -raw admin_password)

LINUX_IP=$(az vm show -d --resource-group "$RG" --name "$NAME" --query "publicIps" -o tsv)

cat <<EOF

LINUX deployment info:

Resource Group:   $RG
Name:             $NAME
Username:         azureuser
Management IP:    $LINUX_IP

EOF

# notice ability to pass commands with script args "$@"
# ssh admin@"$CPMAN_IP" "$@"

# sshpass -p "$ADMIN_PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no admin@"$CPMAN_IP"

ssh azureuser@"$LINUX_IP" "$@"