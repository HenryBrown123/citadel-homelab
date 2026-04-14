# Citadel - Infrastructure Homelab

Central infrastructure server for hbprojects.app projects.

## Architecture

Each concern is a self-contained slice:

```
server/      → Terraform provisioning + bootstrap
vault/       → HashiCorp Vault (secrets)
monitoring/  → Uptime Kuma (uptime alerts)
logs/        → Dozzle (Docker log viewer)
proxy/       → Nginx + Certbot (SSL + routing)
```

## Quick start

### 1. Provision
```sh
source ~/.config/terraform/citadel.env
cd server/terraform
terraform init && terraform apply
```

### 2. Deploy
```sh
ssh root@$(terraform output -raw server_ip)
cd /opt && git clone https://github.com/YOUR_USERNAME/citadel-homelab.git citadel
cd citadel && bash server/bootstrap.sh
```

### 3. Initialize Vault
Visit https://vault.citadel.hbprojects.app — save unseal key + root token.

## Services

| Service | URL | Docs |
|---------|-----|------|
| Vault | vault.citadel.hbprojects.app | [vault/README.md](vault/README.md) |
| Monitor | monitor.citadel.hbprojects.app | [monitoring/README.md](monitoring/README.md) |
| Logs | logs.citadel.hbprojects.app | [logs/README.md](logs/README.md) |

## Adding a new service

1. Create a new directory with its own `docker-compose.yml`
2. Add it to the root `docker-compose.yml` includes
3. Add an nginx server block in `proxy/nginx.conf`
4. `docker compose up -d`

No DNS changes needed — wildcard record handles `*.citadel.hbprojects.app`.

## Adding a demo project

Demo projects live under `demos/` and are served as static sites through the main nginx proxy.

1. Create `demos/my-app/` with a `dist/` directory for the built static files
2. Mount the dist directory into the main nginx container in `proxy/docker-compose.yml`:
   ```yaml
   - ../demos/my-app/dist:/usr/share/nginx/demos/my-app:ro
   ```
3. Add a server block in `proxy/nginx.conf`:
   ```nginx
   server {
       listen 443 ssl;
       server_name my-app.hbprojects.app;

       ssl_certificate /etc/nginx/certs/origin.pem;
       ssl_certificate_key /etc/nginx/certs/origin-key.pem;

       root /usr/share/nginx/demos/my-app;
       index index.html;

       location / {
           limit_req zone=general burst=20 nodelay;
           try_files $uri $uri/ /index.html;
       }
   }
   ```
4. Add the server name to the HTTP redirect block at the top of `proxy/nginx.conf`
5. Add a Cloudflare DNS A record in `server/terraform/main.tf`
6. Optionally add a Cloudflare Access policy in `access.tf` if you want it behind auth
7. Push to main — the citadel deploy handles the rest

The demo app's own repo needs a GitHub Actions workflow that builds and rsyncs its `dist/` to `/opt/citadel/demos/my-app/dist/` on the server. See `music-visualiser` for a working example.
