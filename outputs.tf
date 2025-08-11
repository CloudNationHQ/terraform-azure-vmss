output "vmss" {
  description = "contains all virtual machine scale set config"
  value       = var.vmss.type == "linux" ? try(azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.name], null) : try(azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.name], null)
}

output "subscriptionId" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}
