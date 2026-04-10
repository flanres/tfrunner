# APIM_RG（APIM構成図 1ページ目）Terraform 一式

本リポジトリは、APIM構成図 1ページ目の `APIM_RG`（リソースグループ内）を対象に Terraform で構築するためのテンプレートです。
ディレクトリ構成・運用方針は `terraFormOnlyInstruction.md` の推奨に合わせています。

## 対象（APIM_RG 内）
- VNet（APIM vNet）/ Subnets（AzureFirewallSubnet, AzureFirewallManagementSubnet, APIManagement Subnet, Nat subnet, PE Subnet）
- Azure Firewall（管理NIC有効）+ Firewall Policy（FQDNホワイトリスト方式）
- APIM（Internal, VNet統合）
- NAT Gateway（アウトバウンド固定IP用途：今は有効）
- UDR（APIM Subnet の 0.0.0.0/0 を Firewall へ）
- (任意) Private Endpoint (Blob) ※用途未確定のためデフォルト無効

## 重要な前提（今回の更新点）
- Front Door は「設置されない可能性が高い」ため、APIM Subnet の受信制御は **Application Gateway からの接続のみ**を想定した変数/NSGに変更しました。
  - 実際の Application Gateway は APIM_RG 外に存在し得るため、送信元プレフィックスは `appgw_allowed_source_prefixes` に TODO 値で指定します。

## 使い方（dev 例）
```bash
cd envs/dev

terraform init -backend-config=backend.hcl
terraform fmt -check -recursive
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## TODO の探し方
```bash
grep -R "TODO" -n .
```
