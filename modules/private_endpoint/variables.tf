variable "name" {
  type        = string
  description = "Private Endpoint 名"
}

variable "resource_group_name" {
  type        = string
  description = "対象 Resource Group 名"
}

variable "location" {
  type        = string
  description = "Azure リージョン"
}

variable "subnet_id" {
  type        = string
  description = "Private Endpoint を作成する Subnet ID"
}

variable "target_resource_id" {
  type        = string
  description = "接続先リソースの Resource ID（例: Storage Account）"
}

variable "subresource_names" {
  type        = list(string)
  description = "Private Link の subresource_names（例: ['blob']）"
}

variable "private_dns_zone_ids" {
  type        = list(string)
  description = "関連付ける Private DNS Zone IDs（任意）"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "共通タグ"
  default     = {}
}
