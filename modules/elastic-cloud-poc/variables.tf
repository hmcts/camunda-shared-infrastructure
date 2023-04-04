variable "product" {
  description = "https://hmcts.github.io/glossary/#product"
}
variable "location" {
  description = "Target Azure location to deploy the resource"
  default = "UK South"
}
variable "env" {
  description = "Environment value"
}
variable "common_tags" {
  description = "Common tags to be applied to resources"
  type = map(any)
}

variable "elastic_cloud_email_address" {
  description = "Specifies the Email Address which should be associated with this Elasticsearch account. Changing this forces a new Elasticsearch to be created"
}
