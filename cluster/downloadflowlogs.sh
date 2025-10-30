#!/usr/bin/env bash

set -euo pipefail

STORAGE_ACCOUNT=$(terraform output -raw flowlogs_sa)
CONTAINER="insights-logs-flowlogflowevent"

# az storage blob list --account-name "$STORAGE_ACCOUNT" --container-name "$CONTAINER" -o table

az storage blob list --account-name "$STORAGE_ACCOUNT" --container-name "$CONTAINER" -o tsv --query "[].name" 2>/dev/null | while read -r BLOB_NAME; do
    echo
    echo "Downloading blob: $BLOB_NAME"

    TMPFILE=$(mktemp -p ../_flowlogs)
    az storage blob download \
      --account-name "$STORAGE_ACCOUNT" \
      --container-name "$CONTAINER" \
      --name "$BLOB_NAME" \
      --file "$TMPFILE" --no-progress # >/dev/null 2>/dev/null

    echo "Downloaded to file: $TMPFILE"
done

echo "✅ All blobs downloaded."

ls -lh ../_flowlogs