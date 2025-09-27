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

az config set extension.use_dynamic_install=yes_without_prompt
az config set extension.dynamic_install_allow_preview=true

az provider register --namespace Microsoft.Support
az provider register --namespace Microsoft.SerialConsole

az serial-console connect --resource-group $RG --name "${NAME}" 


