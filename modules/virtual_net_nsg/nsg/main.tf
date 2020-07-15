resource "azurerm_network_security_group" "nsg_example" {
  name                = var.nsgname
  location            = var.location
  resource_group_name = var.resname


  tags = var.tags
}
resource "azurerm_network_security_rule" "example_rule_1" {
  name                        = "sql-outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resname
  network_security_group_name = azurerm_network_security_group.nsg_example.name
}
resource "azurerm_network_security_rule" "example_rule_2_RDP" {
  count    = length(var.rules)
  name     = lookup(var.rules[count.index], "name", "default")
  priority = lookup(var.rules[count.index], "priority", 4000)
  direction = lookup(var.rules[count.index], "direction", "Inbound")
  access    = lookup(var.rules[count.index], "access", "Allow")
  protocol = lookup(var.rules[count.index], "protocol", "Tcp")
  source_port_range     = lookup(var.rules[count.index], "source_port_range", "*")
  source_address_prefix = lookup(var.rules[count.index], "source_address_prefix", "VirtualNetwork")
  destination_port_range     = lookup(var.rules[count.index], "destination_port_range", "443")
  destination_address_prefix = lookup(var.rules[count.index], "destination_address_prefix", "*")
  description = lookup(var.rules[count.index], "description", "default")
  resource_group_name         = var.resname
  network_security_group_name = azurerm_network_security_group.nsg_example.name
}
