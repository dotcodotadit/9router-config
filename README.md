# 9Router Deployment

Production deployment of [9Router](https://github.com/decolua/9router) —
AI Router & Token Saver for Claude Code, Cursor, Codex, and 40+ AI providers.

## Services on This VPS

| Service | Domain | Port | Source |
|---------|--------|------|--------|
| 9Router | router.tibatiba-sah.biz.id | 20128 | Docker (`decolua/9router:latest`) |
| AI Gateway | ai.tibatiba-sah.biz.id | 4000 | Python (`~/ai-gateway/`) |
| Seragam Dashboard | seragam.tibatiba-sah.biz.id | 5000 | Python (`~/seragam-dashboard/`) |

## Prerequisites

- Docker Engine 25+ with Compose plugin (`docker compose version`)
- Caddy installed for reverse proxy (see [INSTALL.md](docs/INSTALL.md))
- `.env` file with secrets populated (see below)

## Quick Start

```bash
# 1. Clone & enter directory
cd /home/ubuntu/9router

# 2. Create .env from example (EDIT THIS — replace all CHANGE_ME)
cp .env.example .env
nano .env

# 3. Start 9router
docker compose up -d

# 4. Verify running
docker compose ps
curl -s http://127.0.0.1:20128/api/health
```

Dashboard: https://router.tibatiba-sah.biz.id

## Configuration

Edit `.env` for secrets. See `.env.example` for all variables.

Key variables:
- `INITIAL_PASSWORD` — first login password
- `JWT_SECRET` — JWT signing secret
- `BASE_URL` — production domain (e.g. `https://router.tibatiba-sah.biz.id`)
- `API_KEY_SECRET` — HMAC secret for API keys
- `AUTH_COOKIE_SECURE=true` — behind HTTPS proxy
- `REQUIRE_API_KEY=true` — enforce API key on /v1/*

## Scripts

```bash
# Backup
./scripts/backup.sh

# Restore
./scripts/restore.sh backups/9router-20260722-0700.tar.gz

# Update to latest image
./scripts/update.sh
```

## Caddy Configuration

Edit `/etc/caddy/Caddyfile` (system) or `caddy/Caddyfile` (repo copy).

```caddyfile
router.tibatiba-sah.biz.id {
    reverse_proxy localhost:20128
}
```

Load new config: `sudo systemctl reload caddy`

## License

MIT
