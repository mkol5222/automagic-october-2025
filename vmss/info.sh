#!/bin/bash

set -euo pipefail

RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)
ADMIN_PASSWORD=$(terraform output -raw admin_password)

echo 
echo "CloudGuard VMSS ${NAME} in RG $RG"
echo ""
echo "   admin password is: $ADMIN_PASSWORD"
echo


az vmss list-instances --resource-group $RG --name $NAME -o table
echo

