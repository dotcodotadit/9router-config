#!/bin/bash
set -euo pipefail
cd /home/ubuntu/9router
docker compose pull
docker compose up -d
