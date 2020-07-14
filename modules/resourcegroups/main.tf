resource "azurerm_resource_group" "resource_group" {
  name     = var.resname
  location = var.location
  tags     = var.tags
}
