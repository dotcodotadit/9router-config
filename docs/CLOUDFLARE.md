# Cloudflare DNS Setup

Cloudflare is used purely as DNS + reverse-proxy (CDN + DDoS protection).
9Router itself runs on the VPS behind Cloudflare.

## DNS Records

Create these records in Cloudflare for `yourdomain.com`:

| Type | Name | Value | Proxy |
|------|------|-------|-------|
| A | router | 43.153.219.154 | Proxied (orange cloud) |
| A | ai | 43.153.219.154 | Proxied (orange cloud) |
| A | seragam | 43.153.219.154 | Proxied (orange cloud) |

Notes:
- Proxy mode (orange cloud) puts Cloudflare between visitors and your VPS.
- Cloudflare terminates HTTPS; Caddy uses HTTP from Cloudflare.
- Caddy still issues a Lets Encrypt cert for direct (non-Cloudflare) access.

## TLS Mode

Set Cloudflare SSL/TLS mode to **Full (Strict)**.
This requires the Caddy origin certificate.

## Origin Certificate

Generate an origin certificate from Cloudflare dashboard:
- Dashboard → SSL/TLS → Origin Server → Create Certificate
- Keep private RSA 2,048-bit key
- Place cert at `/etc/caddy/certs/cloudflare-origin.pem` and key at
  `/etc/caddy/certs/cloudflare-origin.key`
- Add to Caddy:
  ```caddyfile
  router.tibatiba-sah.biz.id {
      tls /etc/caddy/certs/cloudflare-origin.pem /etc/caddy/certs/cloudflare-origin.key
      reverse_proxy localhost:20128
  }
  ```

## Option A — Let Caddy Handle TLS (No Cloudflare Proxy)

If you prefer Caddy to issue Lets Encrypt certs directly:
- Set DNS record to **DNS only** (grey cloud)
- Use plain Caddy config:
  ```caddyfile
  router.tibatiba-sah.biz.id {
      reverse_proxy localhost:20128
  }
  ```

## Security Settings (Cloudflare)

- Rate limiting: enable per-IP rules
- Bot fight mode: enabled
- WAF: managed ruleset on
- Bot detection on

## References

- https://developers.cloudflare.com/dns/manage-dns-records/how-to/create-dns-records/
- https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/
