# v4 of this module renames the primary for_each key from "vmss" to "this"
# on each scale-set type and the autoscale setting, aligning with the
# universal "this" convention. These moved blocks migrate existing state
# addresses so consumers upgrade without a destroy/recreate.

moved {
  from = azurerm_linux_virtual_machine_scale_set.this["vmss"]
  to   = azurerm_linux_virtual_machine_scale_set.this["this"]
}

moved {
  from = azurerm_windows_virtual_machine_scale_set.this["vmss"]
  to   = azurerm_windows_virtual_machine_scale_set.this["this"]
}

moved {
  from = azurerm_orchestrated_virtual_machine_scale_set.this["vmss"]
  to   = azurerm_orchestrated_virtual_machine_scale_set.this["this"]
}

moved {
  from = azurerm_monitor_autoscale_setting.this["vmss"]
  to   = azurerm_monitor_autoscale_setting.this["this"]
}
