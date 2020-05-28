terraform {
  backend "azurerm" {
    resource_group_name  = "DAL"
    storage_account_name = "azurermstorage"
    container_name       = "azurermcontainer"
    key                  = "terraform.tfstate"

}
}

resource "azurerm_resource_group" "rg1" {
    name     = "DAL1"
    location = "eastus"
}

provider "azurerm" {
	version = "=2.0.0"
	features {}
}

