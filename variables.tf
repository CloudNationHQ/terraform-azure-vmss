variable "vmss" {
  description = "contains all virtual machine scale set config"
  type        = any

  validation {
    condition     = contains(["windows", "linux"], lookup(var.vmss, "type", ""))
    error_message = "The vmss type must be either 'windows' or 'linux'."
  }

  validation {
    condition = (
      var.vmss.type == "windows" && (
        !can(var.vmss.secrets) || can(var.vmss.secrets.password)
      )
      ) || (
      var.vmss.type == "linux" && (
        !can(var.vmss.secrets) || can(var.vmss.secrets.public_key || can(var.vmss.secrets.password))
      )
    )
    error_message = "For Windows scale sets, 'secrets' must contain 'password'. For Linux scale sets, 'secrets' must contain 'public_key' or 'password'."
  }
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
  default     = {}
}

variable "keyvault" {
  description = "keyvault id to store secrets"
  type        = string
  default     = null
}

variable "location" {
  description = "default azure region and can be used if location is not specified inside the object."
  type        = string
  default     = null
}

variable "resourcegroup" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}
