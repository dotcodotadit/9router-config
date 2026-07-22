#!/bin/bash
set -euo pipefail

BACKUP="${1:?Usage: $0 <backup.tar.gz>}"

if [ ! -f "$BACKUP" ]; then
  echo "Error: backup file not found: $BACKUP" >&2
  exit 1
fi

echo "Restoring from: $BACKUP"

# Stop the container
cd /home/ubuntu/9router
docker compose down

# Extract backup
tar -xzf "$BACKUP" -C /home/ubuntu/9router

# Restart
docker compose up -d

echo "Restore complete. 9router is running."
docker ps --format "table {{.Names}}\t{{.Status}}"
