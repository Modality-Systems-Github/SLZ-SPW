output "resource_group_name" {
description = "The name of the resource group in which the virtual network was created."
value = azurerm_resource_group.resource_group.name
}
output "resource_group_id" {
description = "The ID of the resource group in which the virtual network was created."
value = azurerm_resource_group.resource_group.id
}