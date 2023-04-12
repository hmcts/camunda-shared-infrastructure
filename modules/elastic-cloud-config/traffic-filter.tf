locals {
  region = "azure-uksouth"
}

variable "product" {}
variable "env" {}
variable "private_endpoint_guid" {}

resource "ec_deployment_traffic_filter" "azure" {
  name   = "${var.product}-elastic-cloud-${var.env}"
  region = local.region
  type   = "azure_private_endpoint"

  rule {
    azure_endpoint_name = "${var.product}-elastic-cloud-${var.env}"
    azure_endpoint_guid = var.private_endpoint_guid
  }
}
