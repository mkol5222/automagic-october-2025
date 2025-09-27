#!/bin/bash

set -euo pipefail

RG=$(terraform output -raw rg)
CPMAN_NAME=$(terraform output -raw name)
echo "${RG} ${CPMAN_NAME}"

CPMAN_IP=$(az vm show -d --resource-group "$RG" --name "$CPMAN_NAME" --query "publicIps" -o tsv)
CPMAN_PASS=$(terraform output -raw admin_password)

echo "Waiting for API to be available at Security Management ${CPMAN_IP}"

PAYLOAD=$(jq -n --arg user "admin" --arg pass "$CPMAN_PASS" '{"user": $user, "password": $pass}')

while true; do
    RESP=$(curl -s -m 5 -k "https://${CPMAN_IP}/web_api/login" -H 'Content-Type: application/json' --data "$PAYLOAD" || echo "{}")
    # echo "$RESP" | jq .
    SID=$(echo "$RESP" | jq -r 'try .sid // "null"' 2>/dev/null || echo "null")
    # echo "SID: $SID"

    if [[ "$SID" != "null" ]]; then
        echo "API is available" #, SID: $SID"
        echo -n "Logging out from API... "
        curl -m 5 -s -k "https://${CPMAN_IP}/web_api/logout" \
            -H 'Content-Type: application/json' \
            -H "x-chkp-sid: $SID" \
            --data '{}' | jq -c .
        echo "Done."
        break
    else
        echo "API not available yet, retrying in 5 seconds..."
        sleep 5
    fi
done
