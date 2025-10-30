#!/bin/bash

set -euo pipefail

RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)

echo "Starting VM $NAME in resource group: $RG"
az vm start --resource-group "$RG" --name "${NAME}"