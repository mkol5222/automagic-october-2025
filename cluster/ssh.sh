#!/bin/bash

set -euo pipefail

# if ~/.ssh/id_rsa.pub does not exist, create key without passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi



RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)

ADMIN_PASSWORD=$(dotenvx get -f ../.env -fk ../.env.keys  TF_VAR_cluster_admin_password)


az vm list --resource-group "$RG" -o table

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

echo "Connecting to instance $INSTANCEIP"
IP=$INSTANCEIP
echo "Instance $INSTANCE IP: $IP"

# remove first element of args, because it's the instance id
REST_OF_ARGS=("${@:2}")
# notice ability to pass commands with script args "$@"
ssh admin@"$IP" "${REST_OF_ARGS[@]}"