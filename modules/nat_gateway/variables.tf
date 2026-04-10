variable "resource_group_name" {
  type        = string
  description = "対象 Resource Group 名"
}

variable "location" {
  type        = string
  description = "Azure リージョン"
}

variable "nat_gateway_name" {
  type        = string
  description = "NAT Gateway 名"
}

variable "public_ip_name" {
  type        = string
  description = "NAT Gateway 用 Public IP 名"
}

variable "subnet_id" {
  type        = string
  description = "関連付ける Subnet ID"
}

variable "tags" {
  type        = map(string)
  description = "共通タグ"
  default     = {}
}
