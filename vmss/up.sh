#!/bin/bash

set -euo pipefail

# remove existing MANAGEMENT_IP from .env (if any)
dotenvx set -f ../.env -fk ../.env.keys TF_VAR_MANAGEMENT_IP ""
. ./tfvars.sh

dotenvx run -f ../.env -fk ../.env.keys -- terraform init

dotenvx run -f ../.env -fk ../.env.keys -- terraform apply -auto-approve
