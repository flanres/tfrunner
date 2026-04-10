output "resource_group_name" {
  description = "Resource Group 名"
  value       = module.rg.name
}

output "vnet_id" {
  description = "VNet ID"
  value       = module.network.vnet_id
}

output "apim_id" {
  description = "APIM ID"
  value       = module.apim.id
}

output "apim_gateway_url" {
  description = "APIM Gateway URL"
  value       = module.apim.gateway_url
}

output "apim_private_ip_addresses" {
  description = "APIM Private IPs"
  value       = module.apim.private_ip_addresses
}

output "firewall_public_ip" {
  description = "Firewall Public IP"
  value       = module.firewall.public_ip_address
}

output "firewall_private_ip" {
  description = "Firewall Private IP (UDR next hop)"
  value       = module.firewall.private_ip_address
}

output "nat_gateway_public_ip" {
  description = "NAT Gateway Public IP（未作成の場合 null）"
  value       = try(module.nat_gateway[0].public_ip_address, null)
}

output "blob_private_endpoint_ip" {
  description = "Blob Private Endpoint の IP（未作成の場合 null）"
  value       = try(module.pe_blob[0].private_ip_address, null)
}
