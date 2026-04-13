#!/bin/bash
set -e

DOMAIN="citadel.hbprojects.app"
EMAIL="henry.e.brown@icloud.com"
APP_DIR="/opt/citadel"

cd "$APP_DIR"

echo "=== Generating SSL certificates ==="

mkdir -p proxy/certbot/conf

docker run --rm -p 80:80 \
  -v "$APP_DIR/proxy/certbot/conf:/etc/letsencrypt" \
  certbot/certbot certonly \
  --standalone \
  --non-interactive \
  -d "$DOMAIN" \
  -d "vault.$DOMAIN" \
  -d "monitor.$DOMAIN" \
  -d "logs.$DOMAIN" \
  --agree-tos \
  -m "$EMAIL"

echo "=== Starting all services ==="
docker compose up -d

echo ""
echo "=== Citadel is running ==="
echo ""
echo "  Vault:   https://vault.$DOMAIN"
echo "  Monitor: https://monitor.$DOMAIN"
echo "  Logs:    https://logs.$DOMAIN"
echo ""
echo "  NEXT: Visit Vault URL to initialize."
echo "  Save your unseal key and root token somewhere safe."
echo ""
