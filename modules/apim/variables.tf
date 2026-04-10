variable "name" {
  type        = string
  description = "APIM 名（グローバル一意）"
}

variable "resource_group_name" {
  type        = string
  description = "対象 Resource Group 名"
}

variable "location" {
  type        = string
  description = "Azure リージョン"
}

variable "publisher_name" {
  type        = string
  description = "APIM Publisher Name"
}

variable "publisher_email" {
  type        = string
  description = "APIM Publisher Email"
}

variable "sku_name" {
  type        = string
  description = "APIM SKU（例: Developer_1, Premium_1 等）"
}

variable "virtual_network_type" {
  type        = string
  description = "APIM VNet 種別 (Internal/External/None)"
  default     = "Internal"

  validation {
    condition     = contains(["Internal", "External", "None"], var.virtual_network_type)
    error_message = "virtual_network_type は Internal / External / None のいずれかを指定してください。"
  }
}

variable "subnet_id" {
  type        = string
  description = "APIM を配置する Subnet ID（virtual_network_type!=None の場合必須）"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "APIM の Public Network Access"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "共通タグ"
  default     = {}
}
