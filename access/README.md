# Access — Cloudflare Zero Trust

All citadel services are protected by Cloudflare Access. Users must authenticate via email OTP before reaching any service.

## How it works

1. User visits `vault.citadel.hbprojects.app`
2. Cloudflare intercepts at the edge (before reaching your server)
3. Shows a login page asking for email
4. If email matches the allow list, sends a one-time code
5. User enters code, gets a 24-hour session cookie
6. Cloudflare forwards the request to your server

## Managed in Terraform

Access applications and policies are defined in `server/terraform/access.tf`.

To add another allowed email:
```hcl
include {
  email = [var.admin_email, "colleague@example.com"]
}
```

To add GitHub org-based access instead of email:
```hcl
include {
  github_organization = "your-org"
}
```

## Adding Access to a new service

1. Add a new `cloudflare_zero_trust_access_application` resource
2. Add a corresponding `cloudflare_zero_trust_access_policy`
3. `terraform apply`
