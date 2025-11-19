#!/bin/bash

set -euo pipefail

# if ~/.ssh/id_rsa.pub does not exist, create key without passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi
export TF_VAR_ssh_public_key=$(cat ~/.ssh/id_rsa.pub)

TF_VAR_vwan_sic_key=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_vwan_sic_key)
# if not defined or empty
if [ -z "$TF_VAR_vwan_sic_key" ]; then
  echo "Error: TF_VAR_vwan_sic_key is not set or is empty." >&2
  # generate a random key with openssl - make sure it has only alphanumeric characters
  TF_VAR_vwan_sic_key=$(openssl rand -base64 32 | tr -dc '[:alnum:]' | cut -c1-30)
  echo "Generated random key: $TF_VAR_vwan_sic_key"
  dotenvx set -f ../.env -fk ../.env.keys TF_VAR_vwan_sic_key "$TF_VAR_vwan_sic_key"
  echo "Saved to .env file."
fi

