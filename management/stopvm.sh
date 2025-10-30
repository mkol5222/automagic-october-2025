#!/bin/bash

set -euo pipefail

RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)

echo "Stopping VM $NAME in resource group: $RG"
az vm stop --resource-group "$RG" --name "${NAME}"