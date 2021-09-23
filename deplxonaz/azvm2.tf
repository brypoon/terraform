provider "azurerm" {
  features {}
  skip_provider_registration = true
}
variable "resourcegroupname" {
  default = "1-8a3e5a0b-playground-sandbox"
}
variable "region" {
  default = "East US"
}
variable "region2" {
  default = "West US"
}
resource "azurerm_virtual_network" "tfvnet" {
  name = "labvnet"
  # address space needs a list format
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = var.resourcegroupname

  tags = {
    environment = "Terraform Vnet"
  }
}
resource "azurerm_virtual_network" "tfvnet2" {
  name = "labvnet2"
  # address space needs a list format
  address_space       = ["172.16.0.0/16"]
  location            = var.region2
  resource_group_name = var.resourcegroupname

  tags = {
    environment = "Terraform Vnet"
  }
}
# Create subnet
resource "azurerm_subnet" "tfsubnet1" {
  name                 = "mysubnet1"
  resource_group_name  = var.resourcegroupname
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  address_prefixes       = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "tfsubnet2" {
  name                 = "mysubnet2"
  resource_group_name  = var.resourcegroupname
  virtual_network_name = azurerm_virtual_network.tfvnet2.name
  address_prefixes     = ["172.16.0.0/24"]
}
resource "azurerm_public_ip" "example1" {
  name                = "pubip1"
  location            = var.region
  resource_group_name = var.resourcegroupname
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
resource "azurerm_public_ip" "example2" {
  name                = "pubip2"
  location            = var.region2
  resource_group_name = var.resourcegroupname
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
# resource "azurerm_public_ip" "example2" {
#   name                = "pubip2"
#   location            = var.region2
#   availability_zone   = "No-Zone"
#   resource_group_name = var.resourcegroupname
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }
resource "azurerm_network_interface" "example1" {
  name                = "lab-nic1" #var.nic_id
  location            = var.region
  resource_group_name = var.resourcegroupname
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.tfsubnet1.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.example1.id
  }
}
resource "azurerm_network_interface" "example2" {
  name                = "lab-nic2" #var.nic_id
  location            = var.region2
  resource_group_name = var.resourcegroupname
  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = azurerm_subnet.tfsubnet2.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.example2.id
  }
}
resource "azurerm_storage_account" "sa" {
  name                     = "labvmstorewhoohooo" #var.bdiag
  resource_group_name      = var.resourcegroupname
  location                 = var.region
  account_tier             = "standard"
  account_replication_type = "LRS"
}
resource "azurerm_virtual_machine" "example1" {
  name                             = "labvm1" #var.servername
  location                         = var.region
  resource_group_name              = var.resourcegroupname
  network_interface_ids            = [azurerm_network_interface.example1.id]
  vm_size                          = "standard_b1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = false
  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntuserver"
    sku       = "18.04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "fromimage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "labvm1"
    admin_username = "vmadmin"
    admin_password = "Password123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
  }
}
resource "azurerm_virtual_machine" "example2" {
  name                             = "labvm2" #var.servername
  location                         = var.region2
  resource_group_name              = var.resourcegroupname
  network_interface_ids            = [azurerm_network_interface.example2.id]
  vm_size                          = "standard_b1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = false
  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntuserver"
    sku       = "18.04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk2"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "fromimage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "labvm2"
    admin_username = "vmadmin"
    admin_password = "Password123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
  }
}