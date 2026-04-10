output "id" {
  description = "Firewall ID"
  value       = azurerm_firewall.this.id
}

output "public_ip_address" {
  description = "Firewall Public IP"
  value       = azurerm_public_ip.firewall.ip_address
}

output "private_ip_address" {
  description = "Firewall Private IP (UDR next hop)"
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

output "policy_id" {
  description = "Firewall Policy ID"
  value       = azurerm_firewall_policy.this.id
}
