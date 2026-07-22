#!/bin/bash
set -euo pipefail
DATE=$(date +%Y%m%d-%H%M)
mkdir -p /home/ubuntu/backups
tar -czf /home/ubuntu/backups/9router-$DATE.tar.gz -C /home/ubuntu/9router .
echo "Backup saved to /home/ubuntu/backups/9router-$DATE.tar.gz"
