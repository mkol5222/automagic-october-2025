#!/bin/bash

set -euo pipefail

. ./tfvars.sh

dotenvx run -f ../.env -fk ../.env.keys -- terraform destroy -auto-approve -target module.flowlogs
