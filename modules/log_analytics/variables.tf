variable "resname" {
  description = "Resource group name"
  default     = "SBD-RG-OPS"
}

variable "location" {
  default     = "UK South"
  description = "Location of the resources"
}

variable "prefix" {
  description = "(Optional) Prefix to add to resources"
  default     = "sbd-"
}

variable "name" {
  default     = "la-slz"
  description = "Log Analytics workspace name"

}

variable "solution_plan_map" {
  description = "(Optional) Map structure containing the list of solutions to be enabled."
  type        = map
  default = {
    ADAssessment = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/ADAssessment"
    },
    ADReplication = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/ADReplication"
    },
    AgentHealthAssessment = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/AgentHealthAssessment"
    },
    DnsAnalytics = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/DnsAnalytics"
    },
    KeyVaultAnalytics = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/KeyVaultAnalytics"
    }
  }

}

variable "tags" {
  description = "(Required) tagging for the log analytics workspace"
  type = map
  default = {
    application = "vdc-hub"
    environment = "development"
    buildagent  = "github-actions"
  }
}
