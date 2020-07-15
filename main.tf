provider "azurerm" {
  version = ">= 2.0"
  #tenant_id = ""
  #subscription_id = ""
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "slzstatestore"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
resource "azurerm_resource_group" "example" {
  name     = var.resname
  location = var.location
  tags     = var.tags
}
resource "azurerm_resource_group" "example-1" {
  name     = var.resname2
  location = var.location
  tags     = var.tags
}
module "storage" {
  source               = "./modules/storageaccounts"
  storage_account_name = "${var.prefix}store1${lower(random_id.storage_account.hex)}"
  location             = azurerm_resource_group.example.location
  resourcegroupname    = azurerm_resource_group.example.name
}
module "storage2" {
  source               = "./modules/storageaccounts"
  storage_account_name = "${var.prefix}store2${lower(random_id.storage_account.hex)}"
  Replication_type     = "GRS"
  location             = azurerm_resource_group.example.location
  resourcegroupname    = azurerm_resource_group.example.name
}
resource "random_id" "storage_account" {
  byte_length = 4
}

module "storage3" {
  source               = "./modules/storageaccounts"
  storage_account_name = "${var.prefix}store${lower(random_id.storage_account.hex)}"
  Replication_type     = "GRS"
  location             = azurerm_resource_group.example.location
  resourcegroupname    = azurerm_resource_group.example.name
}

module "network_resourcegroup" {
  source   = "./modules/resourcegroups"
  resname  = var.network_resourcegroup_name
  location = var.location
  tags     = var.tags
}
module "log_analytics_resourcegroup" {
  source   = "./modules/resourcegroups"
  resname  = var.log_analytics_rg
  location = var.location
  tags     = var.tags
}
module "network" {
  source   = "github.com/barryhiggins3/modality-vnet"
  resname  = module.network_resourcegroup.resource_group_name
  location = var.location
  tags     = var.tags
  subnets = [
    {
      subnet_name                      = "web"
      subnet_address_prefix            = "10.0.4.0/24"
      subnet_network_security_group_id = module.virtual_net_nsg.network_security_group_id
    },
    {
      subnet_name                      = "app"
      subnet_address_prefix            = "10.0.5.0/24"
      subnet_network_security_group_id = module.virtual_net_nsg.network_security_group_id
    },
    {
      subnet_name                      = "domain"
      subnet_address_prefix            = "10.0.6.0/24"
      subnet_network_security_group_id = module.virtual_net_nsg.network_security_group_id
    },
    {
      subnet_name                      = "data"
      subnet_address_prefix            = "10.0.7.0/24"
      subnet_network_security_group_id = module.virtual_net_nsg_2.network_security_group_id
    }
    #{
    #subnet_name                      = "AzureBastionSubnet"
    #subnet_address_prefix            = "10.0.200.0/24"
    #subnet_network_security_group_id = null
    #}
  ]
}
resource "azurerm_subnet" "bastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = module.network_resourcegroup.resource_group_name
  virtual_network_name = module.network.name
  address_prefixes       = ["10.0.200.0/24"]
}
module "security_centre" {
  source          = "./modules/securitycentre"
  resname         = var.security_centre_RG_Name
  location        = var.location
  subscription_id = var.subscription_id
  prefix          = var.prefix
}
module "log_analytics" {
  source   = "./modules/log_analytics"
  resname  = module.log_analytics_resourcegroup.resource_group_name
  location = var.location
  tags     = var.tags
  prefix   = var.prefix
  #name                = var.name
  #solution_plan_map   = var.solution_plan_map
  #resource_group_name = var.rg
}
#odule "subnets" {
#source                = "./modules/virtual_net_nsg/subnet"

#resource_group        = var.resource_group_name
#virtual_network_name  = azurerm_virtual_network.vnet.name
#subnets               = var.networking_object.subnets
#tags                  = local.tags
#location              = var.location
#}

module "virtual_net_nsg" {
  nsgname  = "Spaceeye"
  source   = "./modules/virtual_net_nsg/nsg"
  resname  = module.network_resourcegroup.resource_group_name
  location = var.location
  tags     = var.tags
  # virtual_network_name      = azurerm_virtual_network.vnet.name
  # subnets                   = var.networking_object.subnets
  # tags                      = local.tags
  # log_analytics_workspace   = var.log_analytics_workspace
  # diagnostics_map           = var.diagnostics_map

  rules = [
    {
      name                   = "allow-https"
      priority               = "1000"
      protocol               = "Tcp"
      source_address_prefix  = "VirtualNetwork"
      destination_port_range = "443"
      description            = "Allow HTTPS"
    },
    {
      name                   = "allow-ssh"
      priority               = "1010"
      protocol               = "Tcp"
      source_address_prefix  = "VirtualNetwork"
      destination_port_range = "22"
      description            = "Allow SSH"
    },
    {
      name                   = "allow-rdp"
      priority               = "1020"
      protocol               = "*"
      source_address_prefix  = "VirtualNetwork"
      destination_port_range = "3389"
      description            = "Allow RDP"
    },
    {
      name                   = "deny-all"
      priority               = "4000"
      access                 = "Deny"
      protocol               = "*"
      source_address_prefix  = "*"
      destination_port_range = "*"
      description            = "Deny unmatched inbound traffic"
    }
  ]
}
module "virtual_net_nsg_2" {
  nsgname  = "SQL-Allow"
  source   = "./modules/virtual_net_nsg/nsg"
  resname  = module.network_resourcegroup.resource_group_name
  location = var.location
  tags     = var.tags
  # virtual_network_name      = azurerm_virtual_network.vnet.name
  # subnets                   = var.networking_object.subnets
  # tags                      = local.tags
  # log_analytics_workspace   = var.log_analytics_workspace
  # diagnostics_map           = var.diagnostics_map

  rules = [
    {
      name                   = "allow-SQL"
      priority               = "1021"
      protocol               = "Tcp"
      source_address_prefix  = "VirtualNetwork"
      destination_port_range = "1433"
      description            = "Allow SQL"
    },
    {
      name                   = "allow-https"
      priority               = "1022"
      protocol               = "Tcp"
      source_address_prefix  = "VirtualNetwork"
      destination_port_range = "443"
      description            = "Allow HTTPS"
    },
    {
      name                   = "allow-http"
      priority               = "1023"
      protocol               = "Tcp"
      source_address_prefix  = "VirtualNetwork"
      destination_port_range = "80"
      description            = "Allow HTTP"
    },
    {
      name                   = "deny-all"
      priority               = "4000"
      access                 = "Deny"
      protocol               = "*"
      source_address_prefix  = "*"
      destination_port_range = "*"
      description            = "Deny unmatched inbound traffic"
    }
  ]
}

data "azurerm_subscription" "current" {
}

module "policies" {
  source   = "./modules/policies"
  resid    = data.azurerm_subscription.current.id
  location = var.location
}

# module "managementgroups" {
#   source             = "./modules/managementgroups"
#   customerdomainname = var.customerdomainname
# }
