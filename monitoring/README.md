# Monitoring — Uptime Kuma

Lightweight uptime monitoring with alerts.

## First-time setup

1. Visit https://monitor.citadel.hbprojects.app
2. Create admin account
3. Add monitors:
   - codenames: `https://codenames.hbprojects.app/api/health` (60s interval)
   - citadel vault: `https://vault.citadel.hbprojects.app/v1/sys/health` (60s interval)

## Alerts

Set up notifications under Settings → Notifications:
- Discord webhook
- Email (SMTP)
- Telegram bot
