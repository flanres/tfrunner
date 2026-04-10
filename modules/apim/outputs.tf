output "id" {
  description = "APIM ID"
  value       = azurerm_api_management.this.id
}

output "name" {
  description = "APIM 名"
  value       = azurerm_api_management.this.name
}

output "gateway_url" {
  description = "Gateway URL"
  value       = azurerm_api_management.this.gateway_url
}

output "private_ip_addresses" {
  description = "APIM Private IPs（Internal/External + VNet の場合）"
  value       = azurerm_api_management.this.private_ip_addresses
}
