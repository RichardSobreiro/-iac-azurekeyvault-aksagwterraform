data "azurerm_client_config" "current" {}

data "azuread_group" "admin" {
  display_name = var.azuread_key_vault_group
  security_enabled = true
}

resource "azurerm_key_vault" "kv" {
  name                            = "${var.prefix}-kv-${var.sufix}"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false
  sku_name                        = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_group.admin.id

    certificate_permissions = [
      "Backup", 
      "Create", 
      "Delete", 
      "DeleteIssuers", 
      "Get", 
      "GetIssuers", 
      "Import", 
      "List", 
      "ListIssuers", 
      "ManageContacts", 
      "ManageIssuers", 
      "Purge", 
      "Recover", 
      "Restore", 
      "SetIssuers",
      "Update"
    ]

    key_permissions = [
      "Backup", 
      "Create", 
      "Decrypt", 
      "Delete", 
      "Encrypt", 
      "Get", 
      "Import",
      "List", 
      "Purge", 
      "Recover", 
      "Restore", 
      "Sign", 
      "UnwrapKey",
      "Update", 
      "Verify", 
      "WrapKey"
    ]

    secret_permissions = [
      "Backup", 
      "Delete", 
      "Get", 
      "List", 
      "Purge", 
      "Recover", 
      "Restore",
      "Set"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id    = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Backup", 
      "Create", 
      "Delete", 
      "DeleteIssuers", 
      "Get", 
      "GetIssuers", 
      "Import", 
      "List", 
      "ListIssuers", 
      "ManageContacts", 
      "ManageIssuers", 
      "Purge", 
      "Recover", 
      "Restore", 
      "SetIssuers",
      "Update"
    ]

    key_permissions = [
      "Backup", 
      "Create", 
      "Decrypt", 
      "Delete", 
      "Encrypt", 
      "Get", 
      "Import",
      "List", 
      "Purge", 
      "Recover", 
      "Restore", 
      "Sign", 
      "UnwrapKey",
      "Update", 
      "Verify", 
      "WrapKey"
    ]

    secret_permissions = [
      "Backup", 
      "Delete", 
      "Get", 
      "List", 
      "Purge", 
      "Recover", 
      "Restore",
      "Set"
    ]
  }

  network_acls {
    default_action  = "Allow"
    bypass          = "AzureServices"
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "akssshpublickey" {
  name         = "aks-ssh-public-key"
  value        = "aks-ssh-public-key"
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_certificate" "example" {
  name         = "sslcertificate"
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64("domain.pfx")
    password = ""
  }
}