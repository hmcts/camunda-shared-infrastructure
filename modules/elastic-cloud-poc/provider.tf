terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
      version = ">=1.5.0"
    }
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.7.0"
      configuration_aliases = [azurerm.private_endpoints]
    }
  }
}
