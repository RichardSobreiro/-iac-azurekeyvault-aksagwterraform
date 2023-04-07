# Principal
variable "prefix" {
  description = "Prefix used to name resources."
}

variable "sufix" {
  description = "Sufix used to name resources."
}

# Resource Group
variable "location" {
  description = "Azure region for the resource group."
}

# Key Vault
variable "azuread_key_vault_group" {
  description = "Name of the Azure AD Security Group that will receive the access policy permissions."
}

# Tags
variable "tags" {
  type = map

  default = {
    Project = "personal-profile"
  }
}