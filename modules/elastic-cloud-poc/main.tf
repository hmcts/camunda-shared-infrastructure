locals {
  env = var.env == "sandbox" ? "sbox" : var.env

  vnet_rg_name = var.business_area == "sds" ? "ss-${var.env}-network-rg" : "cft-${local.env}-network-rg"
  vnet_name    = var.business_area == "sds" ? "ss-${var.env}-vnet" : "cft-${local.env}-vnet"

  private_endpoint_rg_name   = var.business_area == "sds" ? "ss-${var.env}-network-rg" : "cft-${local.env}-network-rg"
}

resource "azurerm_resource_group" "this" {
  name     = "${var.product}-elastic-cloud-${var.env}"
  location = var.location

  tags = var.common_tags
}

resource "azurerm_elastic_cloud_elasticsearch" "this" {
  name                        = "${var.product}-elastic-cloud-${var.env}"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  sku_name                    = "ess-monthly-consumption_Monthly"
  elastic_cloud_email_address = var.elastic_cloud_email_address

  tags = var.common_tags
}
