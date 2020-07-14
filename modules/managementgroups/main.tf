data "azurerm_subscription" "current" {
}

resource "azurerm_management_group" "customername" {
  display_name = var.customerdomainname

  subscription_ids = [
    #data.azurerm_subscription.current.subscription_id,
  ]
}

resource "azurerm_management_group" "platform" {
  display_name               = "platform"
  parent_management_group_id = azurerm_management_group.customername.id

  subscription_ids = [
    #data.azurerm_subscription.current.subscription_id,
  ]
  # other subscription IDs can go here
}
resource "azurerm_management_group" "connectivity" {
  display_name               = "connectivity"
  parent_management_group_id = azurerm_management_group.platform.id

  subscription_ids = [
    data.azurerm_subscription.current.subscription_id
  ]
}
resource "azurerm_management_group" "management" {
  display_name               = "management"
  parent_management_group_id = azurerm_management_group.platform.id

  subscription_ids = [
      #data.azurerm_subscription.current.subscription_id,
  ]
}