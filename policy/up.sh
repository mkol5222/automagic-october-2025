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

MYIP=$(curl -s https://ipinfo.io/ip)
echo "My public IP is: $MYIP"
export TF_VAR_myip="$MYIP"

export CHECKPOINT_SESSION_NAME="TF VMSS policy $(whoami) $(date) from $(hostname)"
export CHECKPOINT_SESSION_DESCRIPTION="Terraform session description $(date)"

rm sid.json || true # forget previous session
dotenvx run -f ../.env -fk ../.env.keys -- terraform init
if (dotenvx run -f ../.env -fk ../.env.keys -- terraform apply -auto-approve); then
	echo "Terraform apply succeeded";
    export SID=$(jq -r .sid ./sid.json)
	./publish.sh "$SID";
else
    echo "Terraform apply failed";
    export SID=$(jq -r .sid ./sid.json)
	./discard.sh "$SID"; 
fi
echo "Policy: Done."