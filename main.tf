terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.90.0"
    }
  }
}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_user_assigned_identity" "jenkins" {
  name                = "jenkins-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

data "azurerm_key_vault" "camunda" {
  name                = "camunda-${var.env}"
  resource_group_name = "camunda-${var.env}"
}

resource "azurerm_key_vault_access_policy" "jenkins" {
  key_vault_id = data.azurerm_key_vault.camunda.id
  tenant_id    = var.tenant_id
  object_id    = data.azurerm_user_assigned_identity.jenkins.principal_id

  key_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]

  certificate_permissions = [
    "Get",
    "List",
  ]
}
