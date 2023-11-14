//output "vmss" {
//  description = "contains all virtual machine scale sets"
//  value       = azurerm_linux_virtual_machine_scale_set.vmss
//}

output "vmss" {
  description = "The entire Virtual Machine Scale Set object based on type"
  value       = var.vmss.type == "linux" ? try(azurerm_linux_virtual_machine_scale_set.vmss["vmss"], null) : try(azurerm_windows_virtual_machine_scale_set.vmss["vmss"], null)
}

output "subscriptionId" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}
