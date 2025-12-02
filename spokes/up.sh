#!/bin/bash

set -euo pipefail

MYIP=$(curl -s https://ipinfo.io/ip)
echo "My public IP is: $MYIP"
export TF_VAR_myip="$MYIP"

dotenvx run -f ../.env -fk ../.env.keys -- terraform init

dotenvx run -f ../.env -fk ../.env.keys -- terraform apply -auto-approve