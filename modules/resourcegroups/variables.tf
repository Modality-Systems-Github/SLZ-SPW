variable "location" {
  default = "UK South"
  description = "location details"
  
}
variable "resname" {
  description = "Resource Group Name"
  
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