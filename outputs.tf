output "vmss" {
  description = "contains all virtual machine scale set config"
  value       = var.instance.type == "linux" ? try(azurerm_linux_virtual_machine_scale_set.this["vmss"], null) : var.instance.type == "windows" ? try(azurerm_windows_virtual_machine_scale_set.this["vmss"], null) : try(azurerm_orchestrated_virtual_machine_scale_set.this["vmss"], null)
}
