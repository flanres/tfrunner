# -----------------------------
# 共通
# -----------------------------
variable "project" {
  type        = string
  description = "プロジェクト識別子（命名prefix用）"
}

variable "environment" {
  type        = string
  description = "環境名（例: dev/prod）"
}

variable "location" {
  type        = string
  description = "Azure リージョン（例: japaneast）"
}

variable "location_short" {
  type        = string
  description = "リージョン短縮名（例: jpe）。命名文字数制約回避に利用"
}

variable "resource_group_name" {
  type        = string
  description = "APIM_RG の Resource Group 名（図では APIM_RG）"
  default     = "APIM_RG" # TODO: 命名規則に合わせて変更
}

variable "tags" {
  type        = map(string)
  description = "共通タグ（environment/project/owner 等）"
  default     = {}
}

# -----------------------------
# Network (APIM vNet)
# -----------------------------
variable "vnet_address_space" {
  type        = list(string)
  description = "APIM vNet のアドレス空間"
}

variable "subnet_prefix_firewall" {
  type        = string
  description = "AzureFirewallSubnet CIDR"
}

variable "enable_firewall_management_subnet" {
  type        = bool
  description = "AzureFirewallManagementSubnet を作成するか（管理 NIC を有効化する場合）"
  default     = true
}

variable "subnet_prefix_firewall_mgmt" {
  type        = string
  description = "AzureFirewallManagementSubnet CIDR（enable_firewall_management_subnet=true のとき必須）"
  default     = null
  nullable    = true
}

variable "subnet_prefix_apim" {
  type        = string
  description = "APIManagement Subnet CIDR"
}

variable "enable_nat_subnet" {
  type        = bool
  description = "Nat subnet を作成するか"
  default     = true
}

variable "subnet_prefix_nat" {
  type        = string
  description = "Nat subnet CIDR（enable_nat_subnet=true のとき必須）"
  default     = null
  nullable    = true
}

variable "subnet_prefix_pe" {
  type        = string
  description = "PE Subnet CIDR"
}

# APIM 受信：Application Gateway からの接続のみ（想定）
variable "restrict_apim_inbound_to_appgw" {
  type        = bool
  description = "APIM Subnet の 443 inbound を Application Gateway の送信元に制限するか"
  default     = true
}

variable "appgw_allowed_source_prefixes" {
  type        = list(string)
  description = "Application Gateway の送信元プレフィックス（AppGw subnet CIDR など）。TODO: 実値へ"
  # TODO: 実値に置き換え
  default = ["10.20.0.0/24"]
}

# PE Subnet：APIManagement からの通信のみ許可（想定）
variable "restrict_pe_to_apim_subnet" {
  type        = bool
  description = "PE Subnet への inbound を APIM Subnet のみに制限するか"
  default     = true
}

# -----------------------------
# Firewall
# -----------------------------
variable "allowed_target_fqdns" {
  type        = list(string)
  description = "Firewall で許可する宛先 FQDN（図の A/B 等）"
  default     = []
}

# -----------------------------
# NAT Gateway
# -----------------------------
variable "enable_nat_gateway" {
  type        = bool
  description = "NAT Gateway を作成するか（固定 outbound IP 用）"
  default     = true
}

variable "nat_gateway_association_subnet" {
  type        = string
  description = "NAT Gateway を関連付ける先（apim/nat）。TODO: 図の意図に合わせて選択"
  default     = "apim"

  validation {
    condition     = contains(["apim", "nat"], var.nat_gateway_association_subnet)
    error_message = "nat_gateway_association_subnet は apim または nat を指定してください。"
  }
}

# -----------------------------
# APIM
# -----------------------------
variable "apim_name" {
  type        = string
  description = "APIM 名（グローバル一意）。TODO: 実値へ"
}

variable "apim_sku_name" {
  type        = string
  description = "APIM SKU"
  default     = "Developer_1"
}

variable "apim_publisher_name" {
  type        = string
  description = "APIM Publisher Name"
}

variable "apim_publisher_email" {
  type        = string
  description = "APIM Publisher Email"
}

variable "apim_virtual_network_type" {
  type        = string
  description = "APIM VNet 種別 (Internal/External/None)"
  default     = "Internal"
}

variable "apim_public_network_access_enabled" {
  type        = bool
  description = "APIM の Public Network Access"
  default     = false
}

# -----------------------------
# Routing（APIM Subnet のアウトバウンド経路）
# -----------------------------
variable "apim_outbound_route" {
  type        = string
  description = "APIM Subnet の 0.0.0.0/0 の経路（none/firewall）。図の『外部ドメインの場合はすべて Firewall へ』の反映先。"
  default     = "firewall"

  validation {
    condition     = contains(["none", "firewall"], var.apim_outbound_route)
    error_message = "apim_outbound_route は none または firewall を指定してください。"
  }
}

# -----------------------------
# Private Endpoint (Blob)
# -----------------------------
variable "enable_blob_private_endpoint" {
  type        = bool
  description = "Private Endpoint (Blob) を作成するか（用途未確定のためデフォルト false）"
  default     = false
}

variable "blob_target_resource_id" {
  type        = string
  description = "Blob Private Endpoint の接続先 Resource ID（例: Storage Account）。TODO: 実値へ"
  # TODO: 実値に置き換え（接続先は別RGでも問題ありません）
  default = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/TODO-rg/providers/Microsoft.Storage/storageAccounts/todostorage"
}

variable "blob_private_dns_zone_ids" {
  type        = list(string)
  description = "Blob 用 Private DNS Zone IDs（別RG管理なら空でOK）。TODO: 置き場所を決める"
  default     = []
}
