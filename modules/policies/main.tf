data "azurerm_policy_set_definition" "azure_monitor" {
  display_name = "Enable Azure Monitor for VMs"
}

resource "azurerm_policy_assignment" "Policy-1" {
  name  = "example-policy-assignment"
  scope = var.resid
  # policy_definition_id = data.azurerm_policy_set_definition.example.id
  policy_definition_id = data.azurerm_policy_set_definition.azure_monitor.id
  description          = "Policy assignement to monitor all vms"
  display_name         = "VM monitor initiative"
  location             = var.location
  identity {
    type = "SystemAssigned"
  }
  parameters = <<PARAMETERS
{
  "logAnalytics_1": {
    "value": "594b5afb-b888-4e75-bf99-8e0cbe22a460"
  }
}
PARAMETERS

}

data "azurerm_policy_set_definition" "ISO27001" {
  display_name = "ISO 27001:2013"
}

resource "azurerm_policy_assignment" "Policy-2" {
  name  = "ISO_27001_policy_assignment"
  scope = var.resid
  # policy_definition_id = data.azurerm_policy_set_definition.example.id
  policy_definition_id = data.azurerm_policy_set_definition.ISO27001.id
  description          = "Modality Audit ISO 27001 controls and deploy specific VM Extensions to support audit requirements"
  display_name         = "Modality ISO 27001 Audit policy assignement"
  location             = var.location
  identity {
    type = "SystemAssigned"
  }
}
