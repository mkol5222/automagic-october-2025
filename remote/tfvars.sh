#!/bin/bash

set -euo pipefail

# dotenvx run -f ../.env -fk ../.env.keys -- terraform init

TF_VAR_cluster_admin_password=$(dotenvx get -f ../.env -fk ../.env.keys  TF_VAR_cluster_admin_password)
# if not defined or empty
if [ -z "$TF_VAR_cluster_admin_password" ]; then
  echo "Error: TF_VAR_cluster_admin_password is not set or is empty." >&2
  # generate a random password with openssl
  TF_VAR_cluster_admin_password=$(openssl rand -base64 32)
  echo "Generated random password: $TF_VAR_cluster_admin_password"
  dotenvx set -f ../.env -fk ../.env.keys TF_VAR_cluster_admin_password "$TF_VAR_cluster_admin_password"
  echo "Saved to .env file."
fi

TF_VAR_cluster_sic_key=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_cluster_sic_key)
# if not defined or empty
if [ -z "$TF_VAR_cluster_sic_key" ]; then
  echo "Error: TF_VAR_cluster_sic_key is not set or is empty." >&2
  # generate a random key with openssl - make sure it has only alphanumeric characters
  TF_VAR_cluster_sic_key=$(openssl rand -base64 32 | tr -dc '[:alnum:]' | cut -c1-32)
  echo "Generated random key: $TF_VAR_cluster_sic_key"
  dotenvx set -f ../.env -fk ../.env.keys TF_VAR_cluster_sic_key "$TF_VAR_cluster_sic_key"
  echo "Saved to .env file."
fi

