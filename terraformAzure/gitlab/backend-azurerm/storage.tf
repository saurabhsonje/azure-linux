terraform {
  backend "azurerm" {
    resource_group_name  = "DAL"
    storage_account_name = "azurermstorage"
    container_name       = "azurermcontainer"
    key                  = "terraform.tfstate"
    use_msi              = true
    subscription_id  = "cf97669a-b8a4-471e-b5b7-5f96bf875432"
    tenant_id        = "c160a942-c869-429f-8a96-f8c8296d57db"
}
}
