# Vault — Secrets Management

HashiCorp Vault stores secrets for all projects.

## First-time setup

1. Visit https://vault.citadel.hbprojects.app
2. Choose 1 key share, 1 key threshold (solo use)
3. Click Initialize
4. **Save the unseal key and root token immediately**
5. Unseal with the key
6. Sign in with the root token
7. Enable KV v2 secrets engine at `secret/`

## Storing secrets

```sh
export VAULT_ADDR="https://vault.citadel.hbprojects.app"
export VAULT_TOKEN="your-root-token"

vault kv put secret/codenames \
  db_password="xxx" \
  jwt_secret="xxx" \
  gemini_api_key="xxx"
```

## After server restart

Vault seals on restart. Unseal via UI or CLI:

```sh
docker exec -it citadel-vault vault operator unseal YOUR_UNSEAL_KEY
```
