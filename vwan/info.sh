#!/bin/bash

set -euo pipefail

az config set extension.use_dynamic_install=yes_without_prompt



az network vwan list -o table
az network vhub list -o table

az network virtual-appliance list -o table

az network virtual-appliance list -o json 