provider "azurerm" {
  alias                      = "aks-infra"
  subscription_id            = var.aks_subscription_id
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.mgmt_subscription_id
  features {}
}

#module "elastic_cloud" {
#  source = "./modules/elastic-cloud-poc"
#
#  product = var.product
#  env = var.env
#
#  elastic_cloud_email_address = "tim.jacomb@justice.gov.uk"
#
#  common_tags = var.common_tags
#}

#locals {
#  // Vault name
#  vNetLoadBalancerIp = cidrhost(data.azurerm_subnet.elastic-subnet.address_prefix, -3)
#
#}

#data "azurerm_key_vault_secret" "camunda_elastic_search_public_key" {
#  name         = "${var.product}-ELASTIC-SEARCH-PUB-KEY"
#  key_vault_id = data.azurerm_key_vault.key_vault.id
#}

#
#resource "azurerm_key_vault_secret" "elastic_search_url_key_setting" {
#  name         = "${var.product}-ELASTIC-SEARCH-URL"
#  value        = local.vNetLoadBalancerIp
#  key_vault_id = data.azurerm_key_vault.key_vault.id
#}
#
#resource "azurerm_key_vault_secret" "elastic_search_pwd_key_setting" {
#  name         = "${var.product}-ELASTIC-SEARCH-PASSWORD"
#  value        = module.elastic.elasticsearch_admin_password
#  key_vault_id = data.azurerm_key_vault.key_vault.id
#}
#
#data "azurerm_key_vault_secret" "alerts_email" {
#  name         = "alerts-email"
#  key_vault_id = data.azurerm_key_vault.key_vault.id
#}
