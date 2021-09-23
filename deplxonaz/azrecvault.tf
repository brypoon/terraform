

resource "azurerm_recovery_services_vault" "vault" {
  name                = "terraformrecoveryvault"
  resource_group_name = "1-0af1bbb1-playground-sandbox"
  location            = "East US"
  sku                 = "Standard"
}