#!/bin/bash

set -euo pipefail

# choose NIC and show Azure effective route

NIC=$(az network nic list --query '[].{Name:name, ResourceGroup:resourceGroup}' -o tsv | sort | fzf --prompt="Type to filter NICs: ")
echo $NIC
# split TSV to RG and NIC name
RG=$(echo $NIC | awk '{print $2}')
NIC_NAME=$(echo $NIC | awk '{print $1}')
echo "Resource Group: $RG"
echo "NIC Name: $NIC_NAME"
az network nic show-effective-route-table --resource-group $RG --name $NIC_NAME -o table | batcat --paging=always
