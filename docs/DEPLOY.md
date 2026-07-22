# Deployment Guide — 9Router

This document describes how to deploy 9Router on Ubuntu 24.04 LTS with Docker Compose + Caddy reverse proxy.

## Architecture

```
Internet  ──►  Caddy (:80, :443 HTTPS)
                  │
                  ├─► ai.tibatiba-sah.biz.id  → localhost:4000 (ai-gateway)
                  ├─► seragam.tibatiba-sah.biz.id → localhost:5000 (seragam dashboard)
                  └─► router.tibatiba-sah.biz.id → localhost:20128 (9router Container)
                                                      │
                                                      └─► DATA_DIR=/home/ubuntu/9router/data
```

## Components

| Component | Port | Source |
|-----------|------|--------|
| Caddy | 80, 443 | systemd (`caddy.service`) |
| 9router | 20128 | Docker container (`decolua/9router`) |
| AI Gateway | 4000 | Python (`ai-gateway/`) |
| Seragam Dashboard | 5000 | Python (`seragam-dashboard/`) |

## Initial Setup

```bash
# 1. Install Docker Compose plugin
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 2. Add current user to docker group
sudo usermod -aG docker $USER

# 3. Create deployment directory
mkdir -p /home/ubuntu/9router/{caddy,data,scripts,docs}

# 4. Copy config files
cp docker-compose.yml .env.example /home/ubuntu/9router/

# 5. Create .env from example
cp /home/ubuntu/9router/.env.example /home/ubuntu/9router/.env

# 6. Generate secure secrets
# Edit .env and replace all CHANGE_ME values
```

## Generate Secrets

```bash
# INITIAL_PASSWORD (per host)
echo "INITIAL_PASSWORD=Astra*$(openssl rand -base64 12)"

# JWT_SECRET (32+ chars)
echo "JWT_SECRET=$(openssl rand -base64 36)"

# API_KEY_SECRET (32 hex chars)
echo "API_KEY_SECRET=$(openssl rand -hex 16)"

# MACHINE_ID_SALT (16 hex chars)
echo "MACHINE_ID_SALT=$(openssl rand -hex 8)"
```

## Start Service

```bash
cd /home/ubuntu/9router
docker compose up -d
docker ps   # verify
docker logs -f 9router   # tail logs
```

## Caddy Configuration

```bash
sudo cp /home/ubuntu/9router/caddy/Caddyfile /etc/caddy/Caddyfile
sudo systemctl reload caddy
```

## Verify

```bash
# Container healthcheck
docker ps --format "table {{.Names}}\t{{.Status}}"

# HTTP probe
curl -i http://localhost:20128/

# Public URL (after Caddy + DNS)
curl -i https://router.tibatiba-sah.biz.id/
