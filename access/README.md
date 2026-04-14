# Access

Cloudflare Zero Trust (Access) protects all citadel admin services. Requests are intercepted at Cloudflare's edge before they reach the server. Users must authenticate via email OTP to get a 24-hour session cookie.

## How it works

1. User visits a protected subdomain (e.g. citadel-vault.hbprojects.app)
2. Cloudflare intercepts the request at the edge
3. User is shown a login page and enters their email
4. If the email is on the allow list, Cloudflare sends a one-time code
5. User enters the code and receives a 24-hour session cookie
6. Cloudflare forwards the request to the origin server

## Configuration

Access applications and policies are defined in Terraform at `server/terraform/access.tf`. Each protected service has:

- An **access application** defining the subdomain and session duration
- An **access policy** defining who can authenticate (currently email-based)

Currently protected services: Vault, Monitor, Logs.

Demo apps (e.g. music-visualiser) are intentionally public and not behind Access.

## Maintenance

### Adding access to a new service

1. Add a `cloudflare_zero_trust_access_application` resource in `server/terraform/access.tf`
2. Add a corresponding `cloudflare_zero_trust_access_policy`
3. Run `terraform apply`

### Allowing additional users

Add emails to the policy's include block in `access.tf`:

```hcl
include {
  email = [var.admin_email, "colleague@example.com"]
}
```

### Alternative auth methods

GitHub org-based access can be used instead of email OTP:

```hcl
include {
  github_organization = "henrybrown"
}
```

### Removing access protection

Delete the access application and policy resources from `access.tf` and run `terraform apply`. The service will become publicly accessible (still behind SSL).
