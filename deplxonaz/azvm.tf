
# calls existing subnet and assigns to azurerm_subnet.tfsubnet.id
data "azurerm_subnet" "tfsubnet" {
  name                 = "mysubnet"
  virtual_network_name = "myvnet"
  resource_group_name  = var.resourcegroupname
}
resource "azurerm_public_ip" "example" {
  name                = "pubip1"
  location            = "eastus"
  resource_group_name = var.resourcegroupname
  allocation_method   = "Dynamic"
  sku                 = "basic"
}
resource "azurerm_network_interface" "example" {
  name                = "forge-nic" #var.nic_id
  location            = "eastus"
  resource_group_name = var.resourcegroupname
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.tfsubnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}
resource "azurerm_storage_account" "sa" {
  name                     = "forgebootdiags123" #var.bdiag
  resource_group_name      = var.resourcegroupname
  location                 = "eastus"
  account_tier             = "standard"
  account_replication_type = "LRS"
}
resource "azurerm_virtual_machine" "example" {
  name                             = "forge" #var.servername
  location                         = "eastus"
  resource_group_name              = var.resourcegroupname
  network_interface_ids            = [azurerm_network_interface.example.id]
  vm_size                          = "standard_b1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = false
  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntuserver"
    sku       = "16.04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    disk_size_gb      = "128"
    caching           = "readwrite"
    create_option     = "fromimage"
    managed_disk_type = "standard_lrs"
  }
  os_profile {
    computer_name  = "forge"
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