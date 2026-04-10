variable "name" {
  type        = string
  description = "Resource Group 名"
}

variable "location" {
  type        = string
  description = "Azure リージョン (例: japaneast)"
}

variable "tags" {
  type        = map(string)
  description = "共通タグ"
  default     = {}
}
