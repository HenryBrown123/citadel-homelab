output "server_ip" {
  description = "Public IP of the citadel server"
  value       = hcloud_server.citadel.ipv4_address
}

output "ssh_command" {
  description = "SSH into the server"
  value       = "ssh root@${hcloud_server.citadel.ipv4_address}"
}

output "vault_url" {
  value = "https://${var.subdomain}-vault.hbprojects.app"
}

output "monitor_url" {
  value = "https://${var.subdomain}-monitor.hbprojects.app"
}

output "logs_url" {
  value = "https://${var.subdomain}-logs.hbprojects.app"
}
