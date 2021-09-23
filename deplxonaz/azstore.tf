provider "azurerm" {
}

# resource <"resource you want to create"> <"terraformname">

resource "azurerm_storage_account" "lab" {
  #name of resource in azure
  name                     = "terraformtestlab"
  resource_group_name      = "1-0af1bbb1-playground-sandbox"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Terraform Storage"
    CreatedBy   = "Admin"
  }
}

#create storage container
resource "azurerm_storage_container" "lab" {
  name = "blobcontainer4lab"
  #with this line, you do not need to define the resource group name as it uses existing storage account. <resource>.<terraformname>.name
  storage_account_name  = azurerm_storage_account.lab.name
  container_access_type = "private"
}

#create blob
resource "azurerm_storage_blob" "lab" {
  name                   = "terraformblob"
  storage_account_name   = azurerm_storage_account.lab.name
  storage_container_name = azurerm_storage_container.lab.name
  type                   = "Block"
}

#create fileshare
resource "azurerm_storage_share" "lab" {
  name                 = "terraformdevshare"
  storage_account_name = azurerm_storage_account.lab.name
  quota                = 50
}
