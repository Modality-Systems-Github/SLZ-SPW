resource "azurerm_resource_group" "resource_group" {
  name     = var.resname
  location = var.location
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.prefix}security-service-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "PerGB2018"
}

resource "azurerm_security_center_workspace" "security_center_workspace" {
  scope        = "/subscriptions/${var.subscription_id}"
  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
resource "azurerm_security_center_subscription_pricing" "security_center_subscription_pricing" {
  tier = "Standard"
}
resource "azurerm_log_analytics_solution" "solution-sentinel" {
  solution_name         = "SecurityInsights"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }

}
