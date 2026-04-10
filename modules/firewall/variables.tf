variable "resource_group_name" {
  type        = string
  description = "対象 Resource Group 名"
}

variable "location" {
  type        = string
  description = "Azure リージョン"
}

variable "firewall_name" {
  type        = string
  description = "Azure Firewall 名"
}

variable "firewall_policy_name" {
  type        = string
  description = "Firewall Policy 名"
}

variable "firewall_subnet_id" {
  type        = string
  description = "AzureFirewallSubnet の subnet id"
}

variable "enable_management" {
  type        = bool
  description = "管理 NIC を有効化するか（有効なら AzureFirewallManagementSubnet が必要）"
  default     = true
}

variable "firewall_mgmt_subnet_id" {
  type        = string
  description = "AzureFirewallManagementSubnet の subnet id（enable_management=true のとき必須）"
  default     = null
  nullable    = true

  validation {
    condition     = !var.enable_management || var.firewall_mgmt_subnet_id != null
    error_message = "enable_management=true の場合、firewall_mgmt_subnet_id を指定してください。"
  }
}

variable "firewall_public_ip_name" {
  type        = string
  description = "Firewall 用 Public IP 名"
}

variable "firewall_mgmt_public_ip_name" {
  type        = string
  description = "Firewall 管理用 Public IP 名（enable_management=true のとき作成）"
  default     = null
  nullable    = true
}

variable "allowed_source_addresses" {
  type        = list(string)
  description = "Application rule の送信元アドレス（通常: APIM subnet CIDR など）"
  default     = []
}

variable "allowed_target_fqdns" {
  type        = list(string)
  description = "許可する宛先FQDN（ホワイトリスト）"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "共通タグ"
  default     = {}
}
