#!/bin/bash

set -euo pipefail


RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)

ADMIN_PASSWORD=$(dotenvx get -f ../.env -fk ../.env.keys  TF_VAR_cluster_admin_password)


# az vm list --resource-group "$RG" -o table

NODE1IP=$(az vm show -d --resource-group "$RG" --name "${NAME}1" --query "publicIps" -o tsv | cut -d',' -f1)
NODE2IP=$(az vm show -d --resource-group "$RG" --name "${NAME}2" --query "publicIps" -o tsv | cut -d',' -f1)

cat <<EOF

Cluster deployment info:

Resource Group:   $RG
Name:             $NAME
Admin Username:   admin
Admin Password:   $ADMIN_PASSWORD

Node1 IP:        $NODE1IP
Node2 IP:        $NODE2IP


EOF



# first arg or 0
INSTANCE=${1:-0}

NODEIPS=($NODE1IP $NODE2IP)
# get instance from list
INSTANCEIP=${NODEIPS[$INSTANCE]}
echo "Selected instance: $INSTANCEIP"


HASHED_PASSWORD=$(openssl passwd -1 "$ADMIN_PASSWORD")

SCRIPT=$(cat <<EOF | base64 -w0
#!/bin/bash
clish -s -c 'lock database override'
clish -s -c 'set user admin password-hash $HASHED_PASSWORD'
clish -s -c 'unlock database'
EOF
)

# instance+1
IID=$((INSTANCE+1))
echo "Resetting password on instance ha$IID"
INAME="${NAME}$IID"
echo "Instance name: $INAME"
####
(cd ../management/; ./ssh.sh mgmt_cli -r true run-script targets "$INAME" script-name "Reset_Gateway_Password" script-base64 "$SCRIPT")
