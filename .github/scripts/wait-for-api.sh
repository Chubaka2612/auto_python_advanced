#!/usr/bin/env bash
set -euo pipefail

URL="${1:-http://localhost:5000/apidocs/}"
RETRIES="${2:-30}"
INTERVAL="${3:-2}"

echo "Waiting for API at $URL..."
for i in $(seq 1 "$RETRIES"); do
  if curl -sf "$URL" > /dev/null 2>&1; then
    echo "API is ready after $i attempts"
    exit 0
  fi
  echo "Attempt $i/$RETRIES — retrying in ${INTERVAL}s..."
  sleep "$INTERVAL"
done

echo "API did not become ready in time, dumping logs:"
docker compose logs
exit 1
