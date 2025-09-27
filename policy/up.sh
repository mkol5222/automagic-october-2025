#!/bin/bash

set -euo pipefail

CPMAN_RG=$(cd ../management; terraform output -raw rg)
CPMAN_NAME=$(cd ../management; terraform output -raw name)
CPMAN_ADMIN_PASSWORD=$(cd ../management; terraform output -raw admin_password)

CPMAN_IP=$(az vm show -d --resource-group "$CPMAN_RG" --name "$CPMAN_NAME" --query "publicIps" -o tsv)

export CHECKPOINT_SERVER="$CPMAN_IP"
export CHECKPOINT_USERNAME="admin"
export CHECKPOINT_PASSWORD="$CPMAN_ADMIN_PASSWORD"

cat <<EOF

Management server info:
  Name: $CPMAN_NAME
  IP:   $CHECKPOINT_SERVER
  User: $CHECKPOINT_USERNAME
  Pass: $CHECKPOINT_PASSWORD

EOF

terraform init
terraform apply -auto-approve