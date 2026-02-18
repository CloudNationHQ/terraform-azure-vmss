output "vmss" {
  description = "contains all virtual machine scale set config"
  value       = var.instance.type == "linux" ? try(azurerm_linux_virtual_machine_scale_set.this["vmss"], null) : try(azurerm_windows_virtual_machine_scale_set.this["vmss"], null)
}
