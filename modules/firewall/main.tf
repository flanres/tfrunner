resource "azurerm_public_ip" "firewall" {
  name                = var.firewall_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

resource "azurerm_public_ip" "firewall_mgmt" {
  count = var.enable_management ? 1 : 0

  name                = coalesce(var.firewall_mgmt_public_ip_name, "${var.firewall_public_ip_name}-mgmt")
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                = var.firewall_policy_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = "Standard" # TODO: 要件により Premium へ（TLS Inspection 等）

  tags = var.tags
}

# 許可したいFQDNが無い場合でも apply が通るよう、空ならルールを作らない
resource "azurerm_firewall_policy_rule_collection_group" "this" {
  count = length(var.allowed_target_fqdns) > 0 ? 1 : 0

  name               = "${var.firewall_policy_name}-rcg"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 100

  application_rule_collection {
    name     = "allow-fqdns"
    priority = 100
    action   = "Allow"

    rule {
      name = "allow-outbound-fqdns"

      source_addresses = var.allowed_source_addresses

      protocols {
        type = "Https"
        port = 443
      }

      protocols {
        type = "Http"
        port = 80
      }

      destination_fqdns = var.allowed_target_fqdns
      description       = "Whitelist outbound FQDNs (TODO: replace placeholder FQDNs)"
    }
  }
}

resource "azurerm_firewall" "this" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  firewall_policy_id = azurerm_firewall_policy.this.id

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  dynamic "management_ip_configuration" {
    for_each = var.enable_management ? [1] : []
    content {
      name                 = "mgmtconfig"
      subnet_id            = var.firewall_mgmt_subnet_id
      public_ip_address_id = azurerm_public_ip.firewall_mgmt[0].id
    }
  }

  tags = var.tags
}
