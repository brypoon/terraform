terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  backend "azurerm" {
  storage_account_name = "terratester"
  container_name       = "tfstate"
  key                  = "prod.terraform.tfstate"

  # rather than defining this inline, the Access Key can also be sourced
  # from an Environment Variable - more information is available below.
  access_key = "OXghnezNSBmkiEP1cPkYLDJq2C/73w4mlI6zFC/LGOO7VtbgSnYCV7Cy59KeEkYT3SqukOILpWUzqM7Jiya0QA=="
  }
}
provider "azurerm" {
  features {}
  skip_provider_registration = true
}