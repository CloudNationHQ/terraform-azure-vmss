data "azurerm_subscription" "current" {}

# scale set linux
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  for_each = var.vmss.type == "linux" ? { (var.vmss.type) = true } : {}

  name                = var.vmss.name
  resource_group_name = var.vmss.resourcegroup
  location            = var.vmss.location

  sku                             = try(var.vmss.sku, "Standard_DS1_v2")
  instances                       = try(var.vmss.instances, 2)
  admin_username                  = try(var.vmss.admin_username, "adminuser")
  disable_password_authentication = try(var.vmss.disable_password_authentication, true)
  upgrade_mode                    = try(var.vmss.upgrade_mode, "Automatic")
  provision_vm_agent              = try(var.vmss.provision_vm_agent, true)
  platform_fault_domain_count     = try(var.vmss.platform_fault_domain_count, 5)
  priority                        = try(var.vmss.priority, "Regular")
  secure_boot_enabled             = try(var.vmss.secure_boot_enabled, false)
  vtpm_enabled                    = try(var.vmss.vtpm_enabled, false)
  zone_balance                    = try(var.vmss.zone_balance, false)
  edge_zone                       = try(var.vmss.edge_zone, null)
  encryption_at_host_enabled      = try(var.vmss.encryption_at_host_enabled, false)
  extension_operations_enabled    = try(var.vmss.extension_operations_enabled, true)
  extensions_time_budget          = try(var.vmss.extensions_time_budget, "PT1H30M")
  overprovision                   = try(var.vmss.overprovision, true)
  zones                           = try(var.vmss.zones, ["2"])

  dynamic "admin_ssh_key" {
    for_each = {
      for key in local.ssh_keys : key.ssh_key => key
    }

    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  dynamic "extension" {
    for_each = {
      for ext in local.ext_keys : ext.ext_key => ext
    }

    content {
      name                       = extension.value.name
      publisher                  = extension.value.publisher
      type                       = extension.value.type
      type_handler_version       = extension.value.type_handler_version
      auto_upgrade_minor_version = extension.value.auto_upgrade_minor_version
      automatic_upgrade_enabled  = extension.value.automatic_upgrade_enabled
      force_update_tag           = extension.value.force_update_tag
      protected_settings         = extension.value.protected_settings
      provision_after_extensions = extension.value.provision_after_extensions
      settings                   = extension.value.settings
    }
  }

  source_image_reference {
    publisher = try(var.vmss.image.publisher, "Canonical")
    offer     = try(var.vmss.image.offer, "UbuntuServer")
    sku       = try(var.vmss.image.sku, "18.04-LTS")
    version   = try(var.vmss.image.version, "latest")
  }

  os_disk {
    storage_account_type = try(var.vmss.os_disk.storage_account_type, "Standard_LRS")
    caching              = try(var.vmss.os_disk.caching, "ReadWrite")
  }

  dynamic "network_interface" {
    for_each = {
      for nic in local.interfaces : nic.interface_key => nic
    }

    content {
      name                          = network_interface.value.nic_name
      primary                       = network_interface.value.primary
      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      enable_ip_forwarding          = network_interface.value.enable_ip_forwarding

      ip_configuration {
        name                                         = network_interface.value.ipconf_name
        primary                                      = network_interface.value.primary
        subnet_id                                    = network_interface.value.subnet_id
        application_gateway_backend_address_pool_ids = network_interface.value.application_gateway_backend_address_pool_ids
        application_security_group_ids               = network_interface.value.application_security_group_ids
        load_balancer_backend_address_pool_ids       = network_interface.value.load_balancer_backend_address_pool_ids
        load_balancer_inbound_nat_rules_ids          = network_interface.value.load_balancer_inbound_nat_rules_ids
      }
    }
  }

  dynamic "data_disk" {
    for_each = {
      for disk in local.data_disks : disk.disk_key => disk
    }

    content {
      caching              = data_disk.value.caching
      create_option        = data_disk.value.create_option
      disk_size_gb         = data_disk.value.disk_size_gb
      lun                  = data_disk.value.lun
      storage_account_type = data_disk.value.storage_account_type
    }
  }

  lifecycle {
    ignore_changes = [instances]
  }

  identity {
    type = "SystemAssigned"
  }
}

# scale set windows
resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  for_each = var.vmss.type == "windows" ? { (var.vmss.type) = true } : {}

  name                = var.vmss.name
  resource_group_name = var.vmss.resourcegroup
  location            = var.vmss.location

  sku                  = try(var.vmss.sku, "Standard_DS1_v2")
  instances            = try(var.vmss.instances, 2)
  admin_password       = var.vmss.password
  admin_username       = try(var.vmss.username, "adminuser")
  computer_name_prefix = try(var.vmss.computer_name_prefix, null)

  source_image_reference {
    publisher = try(var.vmss.image.publisher, "MicrosoftWindowsServer")
    offer     = try(var.vmss.image.offer, "WindowsServer")
    sku       = try(var.vmss.image.sku, "2016-Datacenter-Server-Core")
    version   = try(var.vmss.image.version, "latest")
  }

  os_disk {
    storage_account_type = try(var.vmss.os_disk.storage_account_type, "Standard_LRS")
    caching              = try(var.vmss.os_disk.caching, "ReadWrite")
  }

  dynamic "network_interface" {
    for_each = {
      for nic in local.interfaces : nic.interface_key => nic
    }

    content {
      name                          = network_interface.value.nic_name
      primary                       = network_interface.value.primary
      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      enable_ip_forwarding          = network_interface.value.enable_ip_forwarding

      ip_configuration {
        name                                         = network_interface.value.ipconf_name
        primary                                      = network_interface.value.primary
        subnet_id                                    = network_interface.value.subnet_id
        application_gateway_backend_address_pool_ids = network_interface.value.application_gateway_backend_address_pool_ids
        application_security_group_ids               = network_interface.value.application_security_group_ids
        load_balancer_backend_address_pool_ids       = network_interface.value.load_balancer_backend_address_pool_ids
        load_balancer_inbound_nat_rules_ids          = network_interface.value.load_balancer_inbound_nat_rules_ids
      }
    }
  }

  dynamic "data_disk" {
    for_each = {
      for disk in local.data_disks : disk.disk_key => disk
    }

    content {
      caching              = data_disk.value.caching
      create_option        = data_disk.value.create_option
      disk_size_gb         = data_disk.value.disk_size_gb
      lun                  = data_disk.value.lun
      storage_account_type = data_disk.value.storage_account_type
    }
  }

  lifecycle {
    ignore_changes = [instances]
  }

  identity {
    type = "SystemAssigned"
  }
}

# autoscaling
resource "azurerm_monitor_autoscale_setting" "scaling" {
  for_each = try(var.vmss.autoscaling, null) != null ? { (var.vmss.type) = var.vmss.autoscaling } : {}

  name                = "scaler"
  resource_group_name = var.vmss.resourcegroup
  location            = var.vmss.location
  target_resource_id  = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.type].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.type].id

  profile {
    name = "default"
    capacity {
      default = try(var.vmss.autoscaling.default, 1)
      minimum = var.vmss.autoscaling.min
      maximum = var.vmss.autoscaling.max
    }

    dynamic "rule" {
      for_each = {
        for k in local.rules : k.rule_key => k
      }

      content {
        metric_trigger {
          metric_name        = rule.value.metric_name
          metric_resource_id = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.type].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.type].id
          time_aggregation   = rule.value.time_aggregation
          time_window        = rule.value.time_window
          time_grain         = rule.value.time_grain
          statistic          = rule.value.statistic
          operator           = rule.value.operator
          threshold          = rule.value.threshold
        }

        scale_action {
          direction = rule.value.direction
          type      = rule.value.type
          value     = rule.value.value
          cooldown  = rule.value.cooldown
        }
      }
    }
  }
}
