output "id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "Resource Group 名"
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Resource Group リージョン"
  value       = azurerm_resource_group.this.location
}
