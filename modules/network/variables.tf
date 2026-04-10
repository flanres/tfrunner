variable "resource_group_name" {
  type        = string
  description = "対象 Resource Group 名"
}

variable "location" {
  type        = string
  description = "Azure リージョン"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network 名"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNet アドレス空間"
}

variable "subnet_prefix_firewall" {
  type        = string
  description = "AzureFirewallSubnet の CIDR"
}

variable "enable_firewall_management_subnet" {
  type        = bool
  description = "AzureFirewallManagementSubnet を作成するか（管理 NIC を有効化する場合に必要）"
  default     = true
}

variable "subnet_prefix_firewall_mgmt" {
  type        = string
  description = "AzureFirewallManagementSubnet の CIDR（enable_firewall_management_subnet=true のとき必須）"
  default     = null
  nullable    = true

  validation {
    condition     = !var.enable_firewall_management_subnet || var.subnet_prefix_firewall_mgmt != null
    error_message = "enable_firewall_management_subnet=true の場合、subnet_prefix_firewall_mgmt を指定してください。"
  }
}

variable "subnet_prefix_apim" {
  type        = string
  description = "APIManagement Subnet の CIDR"
}

variable "enable_nat_subnet" {
  type        = bool
  description = "Nat subnet を作成するか（図にあるためデフォルト true）"
  default     = true
}

variable "subnet_prefix_nat" {
  type        = string
  description = "Nat subnet の CIDR（enable_nat_subnet=true のとき必須）"
  default     = null
  nullable    = true

  validation {
    condition     = !var.enable_nat_subnet || var.subnet_prefix_nat != null
    error_message = "enable_nat_subnet=true の場合、subnet_prefix_nat を指定してください。"
  }
}

variable "subnet_prefix_pe" {
  type        = string
  description = "PE Subnet の CIDR（Private Endpoint 用）"
}

variable "restrict_apim_inbound_to_appgw" {
  type        = bool
  description = "APIM Subnet の 443 inbound を Application Gateway に制限する（要: 送信元の具体化）。"
  default     = true
}

variable "appgw_allowed_source_prefixes" {
  type        = list(string)
  description = "Application Gateway の送信元アドレス帯（AppGw subnet CIDR 等）。TODO: 実値へ"
  # TODO: 実値に置き換え
  default = ["10.20.0.0/24"]
}

variable "restrict_pe_to_apim_subnet" {
  type        = bool
  description = "PE Subnet への inbound を APIM Subnet 由来に制限する"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "共通タグ"
  default     = {}
}
