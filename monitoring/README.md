# Monitoring

Uptime Kuma provides lightweight uptime monitoring with alerting for all hbprojects.app services. It periodically pings each service endpoint and sends notifications when something goes down.

## Access

- **URL:** https://citadel-monitor.hbprojects.app
- **Auth:** Cloudflare Access (email OTP) + Uptime Kuma admin account
- **Container:** `citadel-monitor`
- **Image:** `louislam/uptime-kuma:1`
- **Data:** Persisted in the `uptime-kuma-data` Docker volume

## Initial setup

1. Visit https://citadel-monitor.hbprojects.app
2. Create an admin account
3. Add monitors for each service:
   - **Codenames:** `https://codenames.hbprojects.app/api/health` (60s interval)
   - **Vault:** `https://citadel-vault.hbprojects.app/v1/sys/health` (60s interval)
   - **Music Visualiser:** `https://music-visualiser.hbprojects.app` (60s interval)

## Maintenance

### Alerts

Configure notifications under Settings > Notifications. Supported channels include Discord webhooks, email (SMTP), and Telegram bots.

### Adding a new monitor

When a new service is deployed, add a monitor for it in the Uptime Kuma UI. Use the service's health check endpoint if it has one, or the root URL for static sites.

### Data

All monitor configuration and history is stored in the `uptime-kuma-data` Docker volume. No manual backups are typically needed as monitors are quick to recreate, but the volume can be backed up if desired.
