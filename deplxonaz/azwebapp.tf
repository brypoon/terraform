resource "azurerm_app_service_plan" "svcplan" {
  name                = "newwebappserviceplan"
  location            = "eastus"
  resource_group_name = var.resourcegroupname

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "appsvc" {
  name                = "webappforstudent"
  location            = "eastus"
  resource_group_name = var.resourcegroupname
  app_service_plan_id = azurerm_app_service_plan.svcplan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}