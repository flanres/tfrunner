# modules/network

APIM_RG 内の VNet/サブネット/NSG を作成します（図: APIM vNet）。

作成するサブネット：
- AzureFirewallSubnet
- AzureFirewallManagementSubnet（管理NICを有効にする場合）
- APIManagement Subnet
- Nat subnet
- PE Subnet（Private Endpoint 用）

NSG:
- APIM Subnet: **Application Gateway からの 443 のみ許可**（送信元プレフィックスは TODO）
- PE Subnet: **APIManagement Subnet からの通信のみ許可**（図の意図の反映）

※ Application Gateway 自体は APIM_RG 外に存在し得るため、本モジュールでは作成しません。
