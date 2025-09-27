#!/bin/bash

set -euo pipefail

dotenvx run -f ../.env -fk ../.env.keys -- terraform destroy -auto-approve
