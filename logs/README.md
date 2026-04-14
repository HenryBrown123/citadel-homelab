# Logs

Dozzle provides a browser-based real-time Docker log viewer. It reads directly from the Docker socket and shows live log output for every container running on the server. No agents, no log storage, no configuration needed.

## Access

- **URL:** https://citadel-logs.hbprojects.app
- **Auth:** Cloudflare Access (email OTP)
- **Container:** `citadel-logs`
- **Image:** `amir20/dozzle:latest`

## How it works

Dozzle mounts the Docker socket read-only (`/var/run/docker.sock:/var/run/docker.sock:ro`) and streams logs from all containers. It does not persist logs to disk. Analytics are disabled via the `DOZZLE_NO_ANALYTICS` environment variable.

## Maintenance

Dozzle is stateless and requires no maintenance. It automatically discovers new containers as they start. If you need to debug a container, visit the URL and select it from the sidebar.

### Future: centralised logging

To aggregate logs from multiple servers (citadel, codenames, future apps), the plan is to replace Dozzle with Loki + Grafana:

1. Replace Dozzle with Loki + Grafana in this directory
2. Add Promtail to each app server to ship logs to Loki
3. Query and dashboard everything in Grafana
