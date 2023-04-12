data "azurerm_resource_group" "private_endpoint_rg" {
  provider = azurerm.private_endpoints

  name = local.private_endpoint_rg_name
}

data "azapi_resource" "elastic_private_endpoint_resource_guid" {
  type      = "Microsoft.Network/privateEndpoints@2022-01-01"
  name      = "${var.product}-elastic-cloud-${var.env}"
  parent_id = data.azurerm_resource_group.private_endpoint_rg.id

  response_export_values = ["properties.resourceGuid"]
}

output "private_endpoint_resource_guid" {
  value = jsondecode(data.azapi_resource.elastic_private_endpoint_resource_guid.output).properties.resourceGuid
}