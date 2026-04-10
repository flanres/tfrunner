output "id" {
  description = "Private Endpoint ID"
  value       = azurerm_private_endpoint.this.id
}

output "private_ip_address" {
  description = "Private Endpoint のプライベートIP（最初のNICの先頭IP）"
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}
