resource "azurerm_storage_account" "files" {
  name                     = "bestrongfiles123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true
}

resource "azurerm_storage_share" "sqlite" {
  name                 = "sqlite"
  storage_account_name = azurerm_storage_account.files.name
  quota                = 5
}
