#!/bin/bash

set -euo pipefail

. ./tfvars.sh
dotenvx run -f ../.env -fk ../.env.keys -- terraform init

dotenvx run -f ../.env -fk ../.env.keys -- terraform apply -auto-approve
