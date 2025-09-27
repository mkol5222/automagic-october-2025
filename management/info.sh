#!/bin/bash

set -euo pipefail

# if ~/.ssh/id_rsa.pub does not exist, create key without passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi



RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)
ADMIN_PASSWORD=$(terraform output -raw admin_password)

CPMAN_IP=$(az vm show -d --resource-group "$RG" --name "$NAME" --query "publicIps" -o tsv)
SUBSCRIPTION_ID=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_subscriptionId)
echo "Subscription: $SUBSCRIPTION_ID"

cat <<EOF

SECURITY MANAGEMENT deployment info:

Resource Group:   $RG
Name:             $NAME
Admin Username:   admin
Admin Password:   $ADMIN_PASSWORD
Management IP:    $CPMAN_IP

EOF

# make Azure Portal web page URL for cpman VM
echo "Azure Portal URL:"
echo "  https://portal.azure.com/#@/resource/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG/providers/Microsoft.Compute/virtualMachines/$NAME/overview"
echo