variable "storage_account_name" {
  description = "the name of the sotrage account"
  default     = "modalityhacksto2"
}
variable "Replication_type" {
default ="LRS"
description ="The type of storage replication"  
}
variable "location" {
  default = "West Europe"
  description = "location details"
  
}
variable "resourcegroupname" {  
}

