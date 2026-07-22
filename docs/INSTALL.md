# Installation Guide — 9Router

## Prerequisites

- Ubuntu 24.04 LTS (or any modern Debian/Ubuntu)
- 1 CPU, 512MB RAM minimum
- Docker Engine 25+ and Docker Compose plugin
- Outbound internet access for image pulls

## Install Docker

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

After this, log out and back in for docker group to take effect.

## Install Caddy (Reverse Proxy)

```bash
sudo apt-get install -y caddy
sudo systemctl enable --now caddy
```

Default config: `/etc/caddy/Caddyfile`

## Pull 9Router Image

```bash
docker pull decolua/9router:latest
```

## Setup Caddy Site

```bash
CADDYFILE=/etc/caddy/Caddyfile
sudo bash -c "cat >> $CADDYFILE <<EOF

router.tibatiba-sah.biz.id {
    reverse_proxy localhost:20128
}
EOF"
sudo systemctl reload caddy
```

## Configure DNS

In your DNS provider (e.g. Cloudflare), point `router.yourdomain.com`
to this server IP address (43.153.219.154 for this deployment).

## Start 9Router

```bash
cd /home/ubuntu/9router
docker compose up -d
```

Dashboard: `https://router.tibatiba-sah.biz.id`
Default login: `INITIAL_PASSWORD` value from `.env`
