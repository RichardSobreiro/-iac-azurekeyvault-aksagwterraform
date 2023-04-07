provider "azurerm" {
  features {
     key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.36.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "ric-eastus-all-rg-terraform"
    storage_account_name = "riceastusallstgterraform"
    container_name       = "ricprdvault"
    key                  = "terraform.tfstate"
  }
}