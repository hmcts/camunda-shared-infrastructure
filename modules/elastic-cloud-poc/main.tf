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

data "azurerm_subnet" "this" {
  provider             = azurerm.private_endpoints
  name                 = "private-endpoints"
  resource_group_name  = local.vnet_rg_name
  virtual_network_name = local.vnet_name
}

resource "azurerm_private_endpoint" "this" {
  provider = azurerm.private_endpoint

  name                = "${var.product}-elastic-cloud-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.this.id

  private_service_connection {
    name                              = "${var.product}-elastic-cloud"
    private_connection_resource_alias = "uksouth-prod-007-privatelink-service.98758729-06f7-438d-baaa-0cb63e737cdf.uksouth.azure.privatelinkservice"
    is_manual_connection              = true
    request_message                   = "${var.product}-elastic-cloud"
  }

  private_dns_zone_group {
    name                 = "${var.product}-elastic-cloud"
    private_dns_zone_ids = [
      "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.uksouth.azure.elastic-cloud.com"
    ]
  }

  tags = var.common_tags
}
