#!/usr/bin/env bash
#
# Usage:
#   ./readflowlog.sh <storage-account-name> [--follow]
#
# Description:
#   Reads and decodes the latest Azure NSG Flow Log from a storage account.
#   If --follow is used, it continuously checks for new flow logs.

set -euo pipefail

# if [ $# -lt 1 ]; then
#   echo "❌ Usage: $0 <storage-account-name> [--follow]"
#   exit 1
# fi

#STORAGE_ACCOUNT="$1"
STORAGE_ACCOUNT=$(terraform output -raw flowlogs_sa)
CONTAINER="insights-logs-flowlogflowevent"
FOLLOW=""

echo "🔍 Monitoring NSG flow logs in storage account: $STORAGE_ACCOUNT"
echo "📦 Container: $CONTAINER"
echo

LAST_BLOB=""

while true; do
  # Find latest blob (sorted by lastModified)
  LATEST_BLOB=$(az storage blob list \
    --account-name "$STORAGE_ACCOUNT" \
    --container-name "$CONTAINER" \
    --query "sort_by([], &properties.lastModified)[-1].name" \
    -o tsv 2>/dev/null || echo "")

  if [ -z "$LATEST_BLOB" ]; then
    echo "⚠️ No flow logs found yet."
  elif [ "$LATEST_BLOB" != "$LAST_BLOB" ]; then
    echo "📄 New flow log found: $LATEST_BLOB"
    echo "⏳ Reading and decoding..."

    TMPFILE=$(mktemp)
    az storage blob download \
    --account-name "$STORAGE_ACCOUNT" \
    --container-name "$CONTAINER" \
    --name "$LATEST_BLOB" \
    --file "$TMPFILE" --no-progress >/dev/null 2>/dev/null

    jq -r . "$TMPFILE" | less
    rm "$TMPFILE"
    # az storage blob download \
    #   --account-name "$STORAGE_ACCOUNT" \
    #   --container-name "$CONTAINER" \
    #   --name "$LATEST_BLOB" \
    #   --file - 2>/dev/null | jq -r .
    #   jq -r '
    #     .records[].properties.flows[].flows[].flowTuples[]? 
    #     | split(",") 
    #     | {
    #         timestamp: (.[0] | tonumber | todateiso8601),
    #         srcIp: .[1],
    #         destIp: .[2],
    #         srcPort: .[3],
    #         destPort: .[4],
    #         protocol: .[5],
    #         direction: .[6],
    #         action: .[7]
    #       }
    #   '

    LAST_BLOB="$LATEST_BLOB"
    echo "✅ Processed at $(date)"
    echo
  
  fi

  
done
echo "👋 Done."