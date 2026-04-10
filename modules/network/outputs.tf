output "vnet_id" {
  description = "VNet ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "VNet 名"
  value       = azurerm_virtual_network.this.name
}

output "subnet_id_firewall" {
  description = "AzureFirewallSubnet ID"
  value       = azurerm_subnet.firewall.id
}

output "subnet_id_firewall_mgmt" {
  description = "AzureFirewallManagementSubnet ID（未作成の場合 null）"
  value       = var.enable_firewall_management_subnet ? azurerm_subnet.firewall_mgmt[0].id : null
}

output "subnet_id_apim" {
  description = "APIManagement Subnet ID"
  value       = azurerm_subnet.apim.id
}

output "subnet_id_nat" {
  description = "Nat subnet ID（未作成の場合 null）"
  value       = var.enable_nat_subnet ? azurerm_subnet.nat[0].id : null
}

output "subnet_id_pe" {
  description = "PE Subnet ID"
  value       = azurerm_subnet.pe.id
}
