variable "vmss" {
  description = "contains all virtual machine scaleset config"
  type        = any

  validation {
    condition     = contains(["windows", "linux"], lookup(var.vmss, "type", ""))
    error_message = "The vmss type must be either 'windows' or 'linux'."
  }
}
