#!/bin/bash

set -euo pipefail

RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)
ADMIN_PASSWORD=$(terraform output -raw admin_password)

echo 
echo "Connecting to serial console of ${NAME} in RG $RG"
echo "   You can disconnect with Ctrl+] and q"
echo "   admin password is: $ADMIN_PASSWORD"
echo

# press any key to continue; to allow copy password
read -n 1 -s -r -p "Press any key to continue"
echo

# first arg or 0
INSTANCE=${1:-0}
# az config set extension.dynamic_install_allow_preview=true
az provider register --namespace Microsoft.Support
az provider register --namespace Microsoft.SerialConsole

# az vmss list-instances --resource-group $RG --name $NAME --query "[].instanceId" -o tsv

echo "Connecting to instance $INSTANCE"
az serial-console connect -n $NAME -g $RG --instance-id "$INSTANCE"
