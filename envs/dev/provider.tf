provider "azurerm" {
  features {}
  # 認証は OIDC を推奨（CI/CD の環境変数で注入）
  # 例:
  #   ARM_USE_OIDC=true
  #   ARM_CLIENT_ID=...
  #   ARM_TENANT_ID=...
  #   ARM_SUBSCRIPTION_ID=...
  subscription_id = "9b0b9579-869e-4de1-b415-f4989caa1d71"
}
