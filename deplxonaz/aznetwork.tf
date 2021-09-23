# create vnet
resource "azurerm_virtual_network" "tfvnet" {
  name = "myvnet"
  # address space needs a list format
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = var.resourcegroupname

  tags = {
    environment = "Terraform Vnet"
  }
}

# Create subnet
resource "azurerm_subnet" "tfsubnet" {
  name                 = "mysubnet"
  resource_group_name  = var.resourcegroupname
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  address_prefix       = "10.0.1.0/24"
}
resource "azurerm_subnet" "tfsubnet2" {
  name                 = "mysubnet2"
  resource_group_name  = var.resourcegroupname
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  address_prefix       = "10.0.2.0/24"
}