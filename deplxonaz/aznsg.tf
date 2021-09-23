provider "azurerm" {
  version = 1.38
}

variable "resourcegroupname" {
  type    = string
  default = "1-8bfa85e4-playground-sandbox"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "mynsg"
  location            = "eastus"
  resource_group_name = var.resourcegroupname
}

resource "azurerm_network_security_rule" "example1" {
  name                        = "web80"
  priority                    = 1001
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroupname
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "example2" {
  name                        = "web8080"
  priority                    = 1000
  direction                   = "inbound"
  access                      = "deny"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroupname
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "example3" {
  name                        = "webout"
  priority                    = 1000
  direction                   = "outbound"
  access                      = "deny"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroupname
  network_security_group_name = azurerm_network_security_group.nsg.name
}