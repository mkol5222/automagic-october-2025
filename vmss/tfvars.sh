#!/bin/bash

set -euo pipefail

# dotenvx run -f ../.env -fk ../.env.keys -- terraform init

TF_VAR_VMSS_ADMIN_PASSWORD=$(dotenvx get -f ../.env -fk ../.env.keys  TF_VAR_VMSS_ADMIN_PASSWORD)
# if not defined or empty
if [ -z "$TF_VAR_VMSS_ADMIN_PASSWORD" ]; then
  echo "Error: TF_VAR_VMSS_ADMIN_PASSWORD is not set or is empty." >&2
  # generate a random password with openssl
  TF_VAR_VMSS_ADMIN_PASSWORD=$(openssl rand -base64 32)
  echo "Generated random password: $TF_VAR_VMSS_ADMIN_PASSWORD"
  dotenvx set -f ../.env -fk ../.env.keys TF_VAR_VMSS_ADMIN_PASSWORD "$TF_VAR_VMSS_ADMIN_PASSWORD"
  echo "Saved to .env file."
fi

TF_VAR_VMSS_SIC_KEY=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_VMSS_SIC_KEY)
# if not defined or empty
if [ -z "$TF_VAR_VMSS_SIC_KEY" ]; then
  echo "Error: TF_VAR_VMSS_SIC_KEY is not set or is empty." >&2
  # generate a random key with openssl
  TF_VAR_VMSS_SIC_KEY=$(openssl rand -base64 32)
  echo "Generated random key: $TF_VAR_VMSS_SIC_KEY"
  dotenvx set -f ../.env -fk ../.env.keys TF_VAR_VMSS_SIC_KEY "$TF_VAR_VMSS_SIC_KEY"
  echo "Saved to .env file."
fi

TF_VAR_MANAGEMENT_IP=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_MANAGEMENT_IP)
# if not defined or empty
if [ -z "$TF_VAR_MANAGEMENT_IP" ]; then
  echo "Error: TF_VAR_MANAGEMENT_IP is not set or is empty." >&2
  CPMAN_RG=$(cd ../management && terraform output -raw rg)
  CPMAN_NAME=$(cd ../management && terraform output -raw name)
  CPMAN_IP=$(az vm show -d --resource-group "$CPMAN_RG" --name "$CPMAN_NAME" --query "publicIps" -o tsv)
  TF_VAR_MANAGEMENT_IP="$CPMAN_IP"
  dotenvx set -f ../.env -fk ../.env.keys TF_VAR_MANAGEMENT_IP "$TF_VAR_MANAGEMENT_IP"
  echo "Saved to .env file."
fi

