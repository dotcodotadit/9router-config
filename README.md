# 9Router Deployment

Production deployment of [9Router](https://github.com/decolua/9router) —
AI Router & Token Saver for Claude Code, Cursor, Codex, and 40+ AI providers.

## Services on This VPS

| Service | Domain | Port | Source |
|---------|--------|------|--------|
| 9Router | router.tibatiba-sah.biz.id | 20128 | Docker (`decolua/9router:latest`) |
| AI Gateway | ai.tibatiba-sah.biz.id | 4000 | Python (`~/ai-gateway/`) |
| Seragam Dashboard | seragam.tibatiba-sah.biz.id | 5000 | Python (`~/seragam-dashboard/`) |

## Quick Start

```bash
cd /home/ubuntu/9router
docker compose up -d
docker logs -f 9router
```

Dashboard: https://router.tibatiba-sah.biz.id

## Configuration

Edit `.env` for secrets. See `.env.example` for all variables.

Key variables:
- `INITIAL_PASSWORD` — first login password
- `JWT_SECRET` — JWT signing secret
- `BASE_URL` — production domain
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

## Caddy Config

Located at `/etc/caddy/Caddyfile` (system) and `caddy/Caddyfile` (repo copy).

## License

MIT
