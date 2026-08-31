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
