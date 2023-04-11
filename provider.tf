provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "private_endpoints"
  subscription_id            = var.aks_subscription_id
}

terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.51.0"
    }
  }
}
