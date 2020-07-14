variable "location" {
  default     = "UK South"
  description = "UK Only"
}
variable "subscription_id" {
  default = "632fe810-836a-4fe4-8a23-c258282b16af"
}
variable "security_centre_RG_Name" {
  default = "RG-Security"

}
variable "network_resourcegroup_name" {
  default = "SBD-RG-NET"
}
variable "customerdomainname" {
  default = "GCI_Test"
  # type = string
}
variable "resname" {
  default = "example-resources"
  # type = string
}
variable "resname2" {
  default = "example-resources-2"
  # type = string
}