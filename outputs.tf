output "virtual_machine_scale_set" {
  description = "contains all virtual machine scale set config"
  value       = var.virtual_machine_scale_set.type == "linux" ? try(azurerm_linux_virtual_machine_scale_set.this["this"], null) : var.virtual_machine_scale_set.type == "windows" ? try(azurerm_windows_virtual_machine_scale_set.this["this"], null) : try(azurerm_orchestrated_virtual_machine_scale_set.this["this"], null)
}

output "extensions" {
  description = "contains all virtual machine scale set extensions config"
  value       = azurerm_virtual_machine_scale_set_extension.this
}

output "autoscale_settings" {
  description = "contains all monitor autoscale settings config"
  value       = azurerm_monitor_autoscale_setting.this
}
