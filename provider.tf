provider "azurerm" {
  features {}
}

provider "ec" {}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "private_endpoints"
  subscription_id            = var.aks_subscription_id
}

terraform {
  backend "azurerm" {}
  required_providers {
    azapi = {
      source = "Azure/azapi"
      version = "1.5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.51.0"
    }
    ec = {
      source = "elastic/ec"
      version = "=0.6.0"
    }
  }
}
