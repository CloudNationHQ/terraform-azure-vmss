locals {
  interfaces = flatten([
    for interface_key, nic in var.vmss.interfaces : {

      interface_key                                = interface_key
      nic_name                                     = "nic-${interface_key}"
      primary                                      = try(nic.primary, false)
      ipconf_name                                  = "ipconf-${interface_key}"
      dns_servers                                  = try(nic.dns_servers, [])
      enable_accelerated_networking                = try(nic.enable_accelerated_networking, false)
      enable_ip_forwarding                         = try(nic.enable_ip_forwarding, false)
      subnet_id                                    = nic.subnet
      application_gateway_backend_address_pool_ids = try(nic.application_gateway_backend_address_pool_ids, [])
      application_security_group_ids               = try(nic.application_security_group_ids, [])
      load_balancer_backend_address_pool_ids       = try(nic.load_balancer_backend_address_pool_ids, [])
      load_balancer_inbound_nat_rules_ids          = try(nic.load_balancer_inbound_nat_rules_ids, [])
    }
  ])
}

locals {
  data_disks = [
    for disk_key, disk in try(var.vmss.disks, {}) : {

      disk_key                       = disk_key
      name                           = try(disk.name, join("-", [var.naming.managed_disk, disk_key])) // https://github.com/hashicorp/terraform-provider-azurerm/issues/23275
      caching                        = try(disk.caching, "ReadWrite")
      create_option                  = try(disk.create_option, "Empty")
      disk_size_gb                   = try(disk.disk_size_gb, 10)
      lun                            = disk.lun
      storage_account_type           = try(disk.storage_account_type, "Standard_LRS")
      disk_encryption_set_id         = try(disk.disk_encryption_set_id, null)
      ultra_ssd_disk_iops_read_write = try(disk.ultra_ssd_disk_iops_read_write, null)
      ultra_ssd_disk_mbps_read_write = try(disk.ultra_ssd_disk_mbps_read_write, null)
      write_accelerator_enabled      = try(disk.write_accelerator_enabled, false)
    }
  ]
}

locals {
  ext_keys = length(lookup(var.vmss, "extensions", {})) > 0 ? {
    for ext_key, ext in lookup(var.vmss, "extensions", {}) :
    "${var.vmss.name}-${ext_key}" => {

      name                       = try(ext.name, ext_key)
      vmss_name                  = var.vmss.name,
      publisher                  = ext.publisher,
      type                       = ext.type,
      type_handler_version       = ext.type_handler_version,
      settings                   = lookup(ext, "settings", {}),
      protected_settings         = lookup(ext, "protected_settings", {}),
      auto_upgrade_minor_version = try(ext.auto_upgrade_minor_version, true)
    }
  } : {}
}

locals {
  rules = flatten([
    for rule_key, rule in try(var.vmss.autoscaling.rules, {}) : {

      rule_key         = rule_key
      metric_name      = rule.metric_name
      time_aggregation = rule.time_aggregation
      time_window      = rule.time_window
      operator         = rule.operator
      threshold        = rule.threshold
      time_grain       = rule.time_grain
      direction        = rule.direction
      type             = rule.type
      value            = rule.value
      cooldown         = rule.cooldown
      statistic        = rule.statistic
    }
  ])
}
