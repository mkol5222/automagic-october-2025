#!/bin/bash

set -euo pipefail

RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)
ADMIN_PASSWORD=$(terraform output -raw admin_password)
SUBSCRIPTION_ID=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_subscriptionId)

IPS=$(az vmss list-instance-public-ips --resource-group "$RG" --name "$NAME" --query "[].ipAddress" -o tsv)

echo 
echo "CloudGuard VMSS ${NAME} in RG $RG"
echo "Subscription: $SUBSCRIPTION_ID"
echo ""
echo "   admin password is: $ADMIN_PASSWORD"
echo "   VMSS instances IPs: $IPS"
echo
echo "Azure Portal URL for VMSS:"
echo "  https://portal.azure.com/#@/resource/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG/providers/Microsoft.Compute/virtualMachineScaleSets/$NAME/overview"
echo

az vmss list-instances --resource-group $RG --name $NAME -o table
echo

