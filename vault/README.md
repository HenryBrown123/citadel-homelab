# Vault

HashiCorp Vault provides centralised secrets management for all hbprojects.app projects. It runs as a Docker container with file-based storage and is accessed via the web UI or CLI. TLS is handled by the nginx proxy, not Vault itself.

## Access

- **URL:** https://citadel-vault.hbprojects.app
- **Auth:** Cloudflare Access (email OTP) + Vault root token
- **Container:** `citadel-vault`
- **Image:** `hashicorp/vault:1.17`
- **Data:** Persisted in the `vault-data` Docker volume

## Initial setup

Only needed once after first provisioning the server.

1. Visit https://citadel-vault.hbprojects.app
2. Choose 1 key share, 1 key threshold (suitable for solo use)
3. Click Initialize
4. Save the unseal key and root token somewhere safe (these cannot be recovered)
5. Unseal with the key
6. Sign in with the root token
7. Enable a KV v2 secrets engine at `secret/`

## Storing and retrieving secrets

```sh
export VAULT_ADDR="https://citadel-vault.hbprojects.app"
export VAULT_TOKEN="your-root-token"

# Store secrets
vault kv put secret/codenames \
  db_password="xxx" \
  jwt_secret="xxx"

# Retrieve secrets
vault kv get secret/codenames
```

## Maintenance

### Unsealing after restart

Vault seals itself every time the container restarts (deploys, server reboots, crashes). This is by design. Unseal via the web UI or CLI:

```sh
docker exec -it citadel-vault vault operator unseal YOUR_UNSEAL_KEY
```

### Backups

Vault data lives in the `vault-data` Docker volume. To back up:

```sh
docker run --rm -v vault-data:/data -v $(pwd):/backup alpine tar czf /backup/vault-backup.tar.gz /data
```

### Configuration

Vault config is at `config/vault.hcl`. Changes require a container restart (`docker restart citadel-vault`) followed by an unseal.
