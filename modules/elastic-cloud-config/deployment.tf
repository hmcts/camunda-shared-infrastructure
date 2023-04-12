#data "ec_stack" "this" {
#  version_regex = "v8.7.0"
#  region        = local.region
#}

#resource "ec_deployment" "this" {
#  # Optional name.
#  name = "${var.product}-elastic-cloud-${var.env}"
#
#  # Mandatory fields
#  region                 = local.region
#  version                = data.ec_stack.this.version
#  deployment_template_id = "aws-io-optimized-v2"
#
#  traffic_filter = [
#    ec_deployment_traffic_filter.azure.id
#  ]
#
#  # Use the deployment template defaults
#  elasticsearch = {
#    hot = {
#      autoscaling = {}
#    }
#  }
#
#  kibana = {}
#}
