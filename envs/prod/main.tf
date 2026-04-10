locals {
  name_prefix = "${var.project}-${var.environment}-${var.location_short}"

  names = {
    vnet              = "${local.name_prefix}-apim-vnet"
    firewall          = "${local.name_prefix}-azfw"
    firewall_policy   = "${local.name_prefix}-azfw-policy"
    firewall_pip      = "${local.name_prefix}-azfw-pip"
    firewall_mgmt_pip = "${local.name_prefix}-azfw-mgmt-pip"
    nat               = "${local.name_prefix}-natgw"
    nat_pip           = "${local.name_prefix}-natgw-pip"
    apim              = var.apim_name
    pe_blob           = "${local.name_prefix}-pe-blob"
  }

  base_tags = merge(
    {
      project     = var.project
      environment = var.environment
      location    = var.location
    },
    var.tags
  )
}

module "rg" {
  source   = "../../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = local.base_tags
}

module "network" {
  source              = "../../modules/network"
  resource_group_name = module.rg.name
  location            = module.rg.location

  vnet_name          = local.names.vnet
  vnet_address_space = var.vnet_address_space

  subnet_prefix_firewall = var.subnet_prefix_firewall

  enable_firewall_management_subnet = var.enable_firewall_management_subnet
  subnet_prefix_firewall_mgmt       = var.subnet_prefix_firewall_mgmt

  subnet_prefix_apim = var.subnet_prefix_apim

  enable_nat_subnet = var.enable_nat_subnet
  subnet_prefix_nat = var.subnet_prefix_nat

  subnet_prefix_pe = var.subnet_prefix_pe

  restrict_apim_inbound_to_appgw = var.restrict_apim_inbound_to_appgw
  appgw_allowed_source_prefixes  = var.appgw_allowed_source_prefixes

  restrict_pe_to_apim_subnet = var.restrict_pe_to_apim_subnet

  tags = local.base_tags
}

module "firewall" {
  source              = "../../modules/firewall"
  resource_group_name = module.rg.name
  location            = module.rg.location

  firewall_name      = local.names.firewall
  firewall_subnet_id = module.network.subnet_id_firewall

  enable_management            = var.enable_firewall_management_subnet
  firewall_mgmt_subnet_id      = module.network.subnet_id_firewall_mgmt
  firewall_public_ip_name      = local.names.firewall_pip
  firewall_mgmt_public_ip_name = local.names.firewall_mgmt_pip

  firewall_policy_name = local.names.firewall_policy

  allowed_source_addresses = [var.subnet_prefix_apim]
  allowed_target_fqdns     = var.allowed_target_fqdns

  tags = local.base_tags
}

# -----------------------------
# ルーティング（APIM Subnet → Firewall）
# -----------------------------
resource "azurerm_route_table" "apim" {
  count = var.apim_outbound_route == "firewall" ? 1 : 0

  name                = "${local.name_prefix}-rt-apim"
  location            = module.rg.location
  resource_group_name = module.rg.name

  route {
    name                   = "default-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = module.firewall.private_ip_address
  }

  tags = local.base_tags
}

resource "azurerm_subnet_route_table_association" "apim" {
  count = var.apim_outbound_route == "firewall" ? 1 : 0

  subnet_id      = module.network.subnet_id_apim
  route_table_id = azurerm_route_table.apim[0].id
}

# -----------------------------
# NAT Gateway（固定 outbound IP 用）
# -----------------------------
module "nat_gateway" {
  count  = var.enable_nat_gateway ? 1 : 0
  source = "../../modules/nat_gateway"

  resource_group_name = module.rg.name
  location            = module.rg.location

  nat_gateway_name = local.names.nat
  public_ip_name   = local.names.nat_pip

  subnet_id = var.nat_gateway_association_subnet == "apim" ? module.network.subnet_id_apim : module.network.subnet_id_nat

  tags = local.base_tags
}

# -----------------------------
# APIM
# -----------------------------
module "apim" {
  source              = "../../modules/apim"
  name                = local.names.apim
  resource_group_name = module.rg.name
  location            = module.rg.location

  publisher_name  = var.apim_publisher_name
  publisher_email = var.apim_publisher_email
  sku_name        = var.apim_sku_name

  virtual_network_type          = var.apim_virtual_network_type
  subnet_id                     = module.network.subnet_id_apim
  public_network_access_enabled = var.apim_public_network_access_enabled

  tags = local.base_tags
}

# -----------------------------
# Private Endpoint (Blob)
# ※今回のスコープ（APIM_RG内）だけで作る場合でも、接続先は別RGのStorageになり得るため変数化
# ※用途未確定のためデフォルト無効（enable_blob_private_endpoint=false）
# -----------------------------
module "pe_blob" {
  count  = var.enable_blob_private_endpoint ? 1 : 0
  source = "../../modules/private_endpoint"

  name                = local.names.pe_blob
  resource_group_name = module.rg.name
  location            = module.rg.location
  subnet_id           = module.network.subnet_id_pe

  target_resource_id = var.blob_target_resource_id # TODO: 実値へ
  subresource_names  = ["blob"]

  private_dns_zone_ids = var.blob_private_dns_zone_ids

  tags = local.base_tags
}
