provider "azurerm" {
  version = ">= 2.0"
  features {}
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = var.resourcegroupname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.Replication_type

  tags = {
    environment = "staging"

  }
}
