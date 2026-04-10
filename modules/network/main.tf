locals {
  subnet_names = {
    firewall      = "AzureFirewallSubnet"
    firewall_mgmt = "AzureFirewallManagementSubnet"
    apim          = "APIManagementSubnet" # TODO: 図の表記/命名規則に合わせて必要なら変更
    nat           = "NatSubnet"           # TODO
    pe            = "PESubnet"            # TODO
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "firewall" {
  name                 = local.subnet_names.firewall
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefix_firewall]
}

resource "azurerm_subnet" "firewall_mgmt" {
  count = var.enable_firewall_management_subnet ? 1 : 0

  name                 = local.subnet_names.firewall_mgmt
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefix_firewall_mgmt]
}

resource "azurerm_subnet" "apim" {
  name                 = local.subnet_names.apim
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefix_apim]
}

resource "azurerm_subnet" "nat" {
  count = var.enable_nat_subnet ? 1 : 0

  name                 = local.subnet_names.nat
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefix_nat]
}

resource "azurerm_subnet" "pe" {
  name                 = local.subnet_names.pe
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefix_pe]

  private_endpoint_network_policies_enabled = false
}

# -----------------------------
# NSG: APIM Subnet（Application Gateway のみ想定）
# -----------------------------
resource "azurerm_network_security_group" "apim" {
  name                = "${var.vnet_name}-apim-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.restrict_apim_inbound_to_appgw ? [1] : []
    content {
      name                       = "allow-https-from-appgw"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefixes    = var.appgw_allowed_source_prefixes # TODO: AppGw subnet CIDR 等を指定
      destination_address_prefix = "*"
      description                = "Allow HTTPS only from Application Gateway (TODO: set real source prefixes)"
    }
  }

  dynamic "security_rule" {
    for_each = var.restrict_apim_inbound_to_appgw ? [1] : []
    content {
      name                       = "deny-https-inbound-others"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Deny HTTPS from others (TODO: add exceptions if required e.g. Bastion/ops)"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "apim" {
  subnet_id                 = azurerm_subnet.apim.id
  network_security_group_id = azurerm_network_security_group.apim.id
}

# -----------------------------
# NSG: PE Subnet（APIManagement からの通信のみ許可）
# -----------------------------
resource "azurerm_network_security_group" "pe" {
  name                = "${var.vnet_name}-pe-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.restrict_pe_to_apim_subnet ? [1] : []
    content {
      name                       = "allow-from-apim-subnet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = var.subnet_prefix_apim
      destination_address_prefix = "*"
      description                = "Allow inbound only from APIM subnet (per diagram) (TODO: add other sources if needed)"
    }
  }

  dynamic "security_rule" {
    for_each = var.restrict_pe_to_apim_subnet ? [1] : []
    content {
      name                       = "deny-inbound-others"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Deny inbound from others"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.pe.id
}
