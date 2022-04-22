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

module "elastic" {
  source                        = "git@github.com:hmcts/cnp-module-elk.git?ref=RDM-13038"
  vmHostNamePrefix                = "cmda-"
  product                       = var.product
  location                      = var.location
  env                           = var.env
  subscription                  = var.subscription
  common_tags                   = var.common_tags
  vNetLoadBalancerIp            = local.vNetLoadBalancerIp
  dataNodesAreMasterEligible    = true
  vmDataNodeCount               = var.vmDataNodeCount
  vmSizeAllNodes                = var.vmSizeAllNodes
  storageAccountType            = var.storageAccountType
  vmDataDiskCount               = 1
  ssh_elastic_search_public_key = data.azurerm_key_vault_secret.camunda_elastic_search_public_key.value
  providers = {
    azurerm           = azurerm
    azurerm.mgmt      = azurerm.mgmt
    azurerm.aks-infra = azurerm.aks-infra
  }
  logAnalyticsId      = data.azurerm_log_analytics_workspace.log_analytics.workspace_id
  logAnalyticsKey     = data.azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  dynatrace_instance  = var.dynatrace_instance
  dynatrace_hostgroup = var.dynatrace_hostgroup
  dynatrace_token     = data.azurerm_key_vault_secret.dynatrace_token.value
  enable_logstash     = false
  enable_kibana       = false
  alerts_email        = data.azurerm_key_vault_secret.alerts_email.value
  esAdditionalYaml     = "action.auto_create_index: .security*,.monitoring*,.watches,.triggered_watches,.watcher-history*,.logstash_dead_letter,.ml*\nxpack.monitoring.collection.enabled: true\nindices.query.bool.max_clause_count: 5092\n"
}

locals {
  // Vault name
  vNetLoadBalancerIp = cidrhost(data.azurerm_subnet.elastic-subnet.address_prefix, -3)

}

data "azurerm_virtual_network" "core_infra_vnet" {
  name                = "core-infra-vnet-${var.env}"
  resource_group_name = "core-infra-${var.env}"
}

data "azurerm_subnet" "elastic-subnet" {
  name                 = "elasticsearch"
  virtual_network_name = data.azurerm_virtual_network.core_infra_vnet.name
  resource_group_name  = data.azurerm_virtual_network.core_infra_vnet.resource_group_name
}

data "azurerm_key_vault" "key_vault" {
  name                = "${var.product}-${var.env}"
  resource_group_name = "${var.product}-${var.env}"
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "hmcts-${var.subscription}"
  resource_group_name = "oms-automation"
}

data "azurerm_key_vault_secret" "camunda_elastic_search_public_key" {
  name         = "${var.product}-ELASTIC-SEARCH-PUB-KEY"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "dynatrace_token" {
  name         = "dynatrace-token"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "elastic_search_url_key_setting" {
  name         = "${var.product}-ELASTIC-SEARCH-URL"
  value        = local.vNetLoadBalancerIp
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "elastic_search_pwd_key_setting" {
  name         = "${var.product}-ELASTIC-SEARCH-PASSWORD"
  value        = module.elastic.elasticsearch_admin_password
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "alerts_email" {
  name         = "alerts-email"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}
