variable "location" {
  default     = "UK South"
  description = "location details"

}
variable "resname" {
  description = "Resource Group Name"
}
variable "subnets" {
  description = "VNET Subnets"
}
variable "vnetname" {
  description = "Resource Group Name"
  default     = "SBD-NET-PROD"
}
variable "address_space" {
  default     = ["10.0.0.0/16"]
  description = "AddressSpace"

}
variable "dns_servers" {
  default     = ["10.0.0.4", "10.0.0.5"]
  description = "DNS Servers"

}
variable "ddos_enabled" {
  default     = false
  description = "DDOS Plan enabled"

}
variable "web_tier" {
  default     = "10.0.1.0/24"
  description = "Web tier subnet"
}
variable "app_tier" {
  default     = "10.0.2.0/24"
  description = "App tier subnet"
}
variable "data_tier" {
  default     = "10.0.3.0/24"
  description = "App tier subnet"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map

  default = {
    application = "vdc-hub"
    environment = "development"
    buildagent  = "github-actions"
  }
}