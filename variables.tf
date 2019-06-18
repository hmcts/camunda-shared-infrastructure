variable "common_tags" {
  type = "map"
}

variable "product" {}

variable "env" {}

variable "location" {
  default = "UK South"
}

variable "tenant_id" {
  type        = "string"
  description = "The Tenant ID of the Azure Active Directory"
}

variable "jenkins_AAD_objectId" {
  type        = "string"
  description = "This is the ID of the Application you wish to give access to the Key Vault via the access policy"
}

variable "managed_identity_object_id" {
  type = "string"
  default = "52003d14-dc00-429a-a50a-be1e60436044"
}