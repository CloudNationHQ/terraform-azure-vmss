data "azurerm_subscription" "current" {}

# scale set linux
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  for_each = var.vmss.type == "linux" ? {
    (var.vmss.name) = true
  } : {}


  name                = var.vmss.name
  resource_group_name = coalesce(lookup(var.vmss, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.vmss, "location", null), var.location)

  sku                                               = try(var.vmss.sku, "Standard_DS1_v2")
  instances                                         = try(var.vmss.instances, 2)
  admin_username                                    = try(var.vmss.admin_username, "adminuser")
  admin_password                                    = try(var.vmss.password, null)
  disable_password_authentication                   = try(var.vmss.disable_password_authentication, true)
  upgrade_mode                                      = try(var.vmss.upgrade_mode, "Automatic")
  provision_vm_agent                                = try(var.vmss.provision_vm_agent, true)
  platform_fault_domain_count                       = try(var.vmss.platform_fault_domain_count, 5)
  priority                                          = try(var.vmss.priority, "Regular")
  secure_boot_enabled                               = try(var.vmss.secure_boot_enabled, false)
  vtpm_enabled                                      = try(var.vmss.vtpm_enabled, false)
  zone_balance                                      = try(var.vmss.zone_balance, false)
  zones                                             = try(var.vmss.zones, ["2"])
  edge_zone                                         = try(var.vmss.edge_zone, null)
  encryption_at_host_enabled                        = try(var.vmss.encryption_at_host_enabled, false)
  extension_operations_enabled                      = try(var.vmss.extension_operations_enabled, true)
  extensions_time_budget                            = try(var.vmss.extensions_time_budget, "PT1H30M")
  overprovision                                     = try(var.vmss.overprovision, true)
  capacity_reservation_group_id                     = try(var.vmss.capacity_reservation_group_id, null)
  computer_name_prefix                              = try(var.vmss.computer_name_prefix, var.vmss.name)
  custom_data                                       = try(var.vmss.custom_data, null)
  do_not_run_extensions_on_overprovisioned_machines = try(var.vmss.do_not_run_extensions_on_overprovisioned_machines, false)
  eviction_policy                                   = try(var.vmss.eviction_policy, null)
  health_probe_id                                   = try(var.vmss.health_probe_id, null)
  host_group_id                                     = try(var.vmss.host_group_id, null)
  max_bid_price                                     = try(var.vmss.max_bid_price, null)
  proximity_placement_group_id                      = try(var.vmss.proximity_placement_group_id, null)
  single_placement_group                            = try(var.vmss.single_placement_group, true)
  source_image_id                                   = try(var.vmss.source_image_id, null)
  user_data                                         = try(var.vmss.user_data, null)
  tags                                              = try(var.vmss.tags, var.tags, null)

  source_image_reference {
    publisher = try(var.vmss.image.publisher, "Canonical")
    offer     = try(var.vmss.image.offer, "UbuntuServer")
    sku       = try(var.vmss.image.sku, "18.04-LTS")
    version   = try(var.vmss.image.version, "latest")
  }

  os_disk {
    storage_account_type = try(var.vmss.os_disk.storage_account_type, "Standard_LRS")
    caching              = try(var.vmss.os_disk.caching, "ReadWrite")

    dynamic "diff_disk_settings" {
      for_each = lookup(var.vmss, "diff_disk_settings", null) != null ? [1] : []

      content {
        option    = lookup(var.vmss.diff_disk_settings, "option", null)
        placement = lookup(var.vmss.diff_disk_settings, "placement", null)
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = lookup(var.vmss, "ultra_ssd_enabled", false) == true ? [1] : []
    content {
      ultra_ssd_enabled = true
    }
  }

  dynamic "admin_ssh_key" {
    for_each = try(var.vmss.public_key, null) != null || try(var.vmss.password, null) == null && try(var.vmss.public_key, null) == null ? [1] : []
    content {
      username   = try(var.vmss.username, "adminuser")
      public_key = try(var.vmss.public_key, null) != null ? var.vmss.public_key : tls_private_key.tls_key[var.vmss.name].public_key_openssh
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = lookup(var.vmss, "automatic_instance_repair", null) != null ? [1] : []

    content {
      enabled      = true
      grace_period = lookup(var.vmss.automatic_instance_repair, "grace_period", "PT30M")
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = lookup(var.vmss, "automatic_os_upgrade_policy", null) != null ? [1] : []

    content {
      disable_automatic_rollback  = try(var.vmss.automatic_os_upgrade_policy.disable_automatic_rollback, null)
      enable_automatic_os_upgrade = try(var.vmss.automatic_os_upgrade_policy.enable_automatic_os_upgrade, null)
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.vmss, "boot_diags", null) != null ? [1] : []
    content {
      storage_account_uri = lookup(var.vmss.boot_diags, "storage_uri", null)
    }
  }

  dynamic "data_disk" {
    for_each = {
      for disk in local.data_disks : disk.disk_key => disk
    }

    content {
      name                           = data_disk.value.name
      caching                        = data_disk.value.caching
      create_option                  = data_disk.value.create_option
      disk_size_gb                   = data_disk.value.disk_size_gb
      lun                            = data_disk.value.lun
      storage_account_type           = data_disk.value.storage_account_type
      disk_encryption_set_id         = data_disk.value.disk_encryption_set_id
      ultra_ssd_disk_iops_read_write = data_disk.value.ultra_ssd_disk_iops_read_write
      ultra_ssd_disk_mbps_read_write = data_disk.value.ultra_ssd_disk_mbps_read_write
      write_accelerator_enabled      = data_disk.value.write_accelerator_enabled
    }
  }

  dynamic "gallery_application" {
    for_each = lookup(var.vmss, "gallery_application", null) != null ? [1] : []
    content {
      version_id             = lookup(var.vmss.gallery_application, "version_id", null)
      configuration_blob_uri = lookup(var.vmss.gallery_application, "configuration_blob_uri", null)
      order                  = lookup(var.vmss.gallery_application, "order", null)
      tag                    = lookup(var.vmss.gallery_application, "tag", null)
    }
  }

  dynamic "identity" {
    for_each = [lookup(var.vmss, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity[var.vmss.name].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
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

  dynamic "plan" {
    for_each = lookup(var.vmss, "plan", null) != null ? [1] : []

    content {
      name      = lookup(var.vmss.plan, "name", null)
      publisher = lookup(var.vmss.plan, "publisher", null)
      product   = lookup(var.vmss.plan, "product", null)
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = lookup(var.vmss, "rolling_upgrade_policy", null) != null ? [1] : []

    content {
      cross_zone_upgrades_enabled             = lookup(var.vmss.rolling_upgrade_policy, "cross_zone_upgrades_enabled", null)
      max_batch_instance_percent              = lookup(var.vmss.rolling_upgrade_policy, "max_batch_instance_percent", null)
      max_unhealthy_instance_percent          = lookup(var.vmss.rolling_upgrade_policy, "max_unhealthy_instance_percent", null)
      max_unhealthy_upgraded_instance_percent = lookup(var.vmss.rolling_upgrade_policy, "max_unhealthy_upgraded_instance_percent", null)
      pause_time_between_batches              = lookup(var.vmss.rolling_upgrade_policy, "pause_time_between_batches", null)
      prioritize_unhealthy_instances_enabled  = lookup(var.vmss.rolling_upgrade_policy, "prioritize_unhealthy_instances_enabled", null)
    }
  }

  dynamic "scale_in" {
    for_each = lookup(var.vmss, "scale_in", null) != null ? [1] : []

    content {
      rule                   = lookup(var.vmss.scale_in, "rule", null)
      force_deletion_enabled = lookup(var.vmss.scale_in, "force_deletion_enabled", null)
    }
  }

  dynamic "secret" {
    for_each = lookup(var.vmss, "secret", null) != null ? [1] : []

    content {
      key_vault_id = lookup(var.vmss.secret, "key_vault_id", null)

      dynamic "certificate" {
        for_each = try(var.vmss.secret.certificate, null) != null ? [1] : []
        content {
          url = certificate.value.url
        }
      }
    }
  }

  dynamic "spot_restore" {
    for_each = lookup(var.vmss, "spot_restore", null) != null ? [1] : []

    content {
      enabled = true
      timeout = lookup(var.vmss, "timeout", "PT1H")
    }
  }

  dynamic "termination_notification" {
    for_each = lookup(var.vmss, "termination_notification", null) != null ? [1] : []

    content {
      enabled = true
      timeout = lookup(var.vmss.termination_notification, "timeout", "PT5M")
    }
  }

  lifecycle {
    ignore_changes = [instances]
  }
}

# secrets
resource "tls_private_key" "tls_key" {
  # workaround, keys used in for each must be known at plan time
  for_each = var.vmss.type == "linux" && lookup(var.vmss, "public_key", {}) == {} && lookup(
  var.vmss, "password", {}) == {} ? { (var.vmss.name) = true } : {}

  algorithm = try(var.vmss.encryption.algorithm, "RSA")
  rsa_bits  = try(var.vmss.encryption.rsa_bits, 4096)
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.vmss.type == "linux" && lookup(var.vmss, "public_key", {}) == {} && lookup(
  var.vmss, "password", {}) == {} ? { (var.vmss.name) = true } : {}

  name         = format("%s-%s-%s", "kvs", var.vmss.name, "pub")
  value        = tls_private_key.tls_key[var.vmss.name].public_key_openssh
  key_vault_id = var.keyvault
  tags         = try(var.vmss.tags, var.tags, null)
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.vmss.type == "linux" && lookup(var.vmss, "public_key", {}) == {} && lookup(
  var.vmss, "password", {}) == {} ? { (var.vmss.name) = true } : {}

  name         = format("%s-%s-%s", "kvs", var.vmss.name, "priv")
  value        = tls_private_key.tls_key[var.vmss.name].private_key_pem
  key_vault_id = var.keyvault
  tags         = try(var.vmss.tags, var.tags, null)
}

resource "random_password" "password" {
  for_each = var.vmss.type == "windows" && lookup(var.vmss, "password", {}) == {} ? { (var.vmss.name) = true } : {}

  length      = 24
  special     = true
  min_lower   = 5
  min_upper   = 7
  min_special = 4
  min_numeric = 5
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.vmss.type == "windows" && lookup(var.vmss, "password", {}) == {} ? { (var.vmss.name) = true } : {}

  name         = format("%s-%s", "kvs", var.vmss.name)
  value        = random_password.password[var.vmss.name].result
  key_vault_id = var.keyvault
  tags         = try(var.vmss.tags, var.tags, null)
}

# scale set windows
resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  for_each = var.vmss.type == "windows" ? {
    (var.vmss.name) = true
  } : {}
  name                = var.vmss.name
  resource_group_name = var.vmss.resource_group
  location            = var.vmss.location

  admin_password = length(lookup(var.vmss, "password", {})) > 0 ? var.vmss.password : azurerm_key_vault_secret.secret[var.vmss.name].value

  sku                                               = try(var.vmss.sku, "Standard_DS1_v2")
  instances                                         = try(var.vmss.instances, 2)
  admin_username                                    = try(var.vmss.admin_username, "adminuser")
  upgrade_mode                                      = try(var.vmss.upgrade_mode, "Automatic")
  provision_vm_agent                                = try(var.vmss.provision_vm_agent, true)
  platform_fault_domain_count                       = try(var.vmss.platform_fault_domain_count, 5)
  priority                                          = try(var.vmss.priority, "Regular")
  secure_boot_enabled                               = try(var.vmss.secure_boot_enabled, false)
  vtpm_enabled                                      = try(var.vmss.vtpm_enabled, false)
  zone_balance                                      = try(var.vmss.zone_balance, false)
  zones                                             = try(var.vmss.zones, ["2"])
  edge_zone                                         = try(var.vmss.edge_zone, null)
  encryption_at_host_enabled                        = try(var.vmss.encryption_at_host_enabled, false)
  extension_operations_enabled                      = try(var.vmss.extension_operations_enabled, true)
  extensions_time_budget                            = try(var.vmss.extensions_time_budget, "PT1H30M")
  overprovision                                     = try(var.vmss.overprovision, true)
  capacity_reservation_group_id                     = try(var.vmss.capacity_reservation_group_id, null)
  computer_name_prefix                              = try(var.vmss.computer_name_prefix, var.vmss.name)
  custom_data                                       = try(var.vmss.custom_data, null)
  do_not_run_extensions_on_overprovisioned_machines = try(var.vmss.do_not_run_extensions_on_overprovisioned_machines, false)
  eviction_policy                                   = try(var.vmss.eviction_policy, null)
  health_probe_id                                   = try(var.vmss.health_probe_id, null)
  host_group_id                                     = try(var.vmss.host_group_id, null)
  max_bid_price                                     = try(var.vmss.max_bid_price, null)
  proximity_placement_group_id                      = try(var.vmss.proximity_placement_group_id, null)
  single_placement_group                            = try(var.vmss.single_placement_group, true)
  source_image_id                                   = try(var.vmss.source_image_id, null)
  user_data                                         = try(var.vmss.user_data, null)
  tags                                              = try(var.vmss.tags, var.tags, null)

  source_image_reference {
    publisher = try(var.vmss.image.publisher, "MicrosoftWindowsServer")
    offer     = try(var.vmss.image.offer, "WindowsServer")
    sku       = try(var.vmss.image.sku, "2016-Datacenter-Server-Core")
    version   = try(var.vmss.image.version, "latest")
  }

  os_disk {
    storage_account_type = try(var.vmss.os_disk.storage_account_type, "Standard_LRS")
    caching              = try(var.vmss.os_disk.caching, "ReadWrite")

    dynamic "diff_disk_settings" {
      for_each = lookup(var.vmss, "diff_disk_settings", null) != null ? [1] : []

      content {
        option    = lookup(var.vmss.diff_disk_settings, "option", null)
        placement = lookup(var.vmss.diff_disk_settings, "placement", null)
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = lookup(var.vmss, "ultra_ssd_enabled", false) == true ? [1] : []
    content {
      ultra_ssd_enabled = true
    }
  }

  dynamic "additional_unattend_content" {
    for_each = lookup(var.vmss, "additional_unattend_content", null) != null ? [1] : []

    content {
      content = lookup(var.vmss.additional_unattend_content, "content", null)
      setting = lookup(var.vmss.additional_unattend_content, "setting", null)
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = lookup(var.vmss, "automatic_os_upgrade_policy", null) != null ? [1] : []

    content {
      disable_automatic_rollback  = try(var.vmss.automatic_os_upgrade_policy.disable_automatic_rollback, null)
      enable_automatic_os_upgrade = try(var.vmss.automatic_os_upgrade_policy.enable_automatic_os_upgrade, null)
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = lookup(var.vmss, "automatic_instance_repair", null) != null ? [1] : []

    content {
      enabled      = true
      grace_period = lookup(var.vmss.automatic_instance_repair, "grace_period", "PT30M")
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.vmss, "boot_diags", null) != null ? [1] : []
    content {
      storage_account_uri = lookup(var.vmss.boot_diags, "storage_uri", null)
    }
  }

  dynamic "data_disk" {
    for_each = {
      for disk in local.data_disks : disk.disk_key => disk
    }

    content {
      name                           = data_disk.value.name
      caching                        = data_disk.value.caching
      create_option                  = data_disk.value.create_option
      disk_size_gb                   = data_disk.value.disk_size_gb
      lun                            = data_disk.value.lun
      storage_account_type           = data_disk.value.storage_account_type
      disk_encryption_set_id         = data_disk.value.disk_encryption_set_id
      ultra_ssd_disk_iops_read_write = data_disk.value.ultra_ssd_disk_iops_read_write
      ultra_ssd_disk_mbps_read_write = data_disk.value.ultra_ssd_disk_mbps_read_write
      write_accelerator_enabled      = data_disk.value.write_accelerator_enabled
    }
  }

  dynamic "gallery_application" {
    for_each = lookup(var.vmss, "gallery_application", null) != null ? [1] : []

    content {
      version_id             = lookup(var.vmss.gallery_application, "version_id", null)
      configuration_blob_uri = lookup(var.vmss.gallery_application, "configuration_blob_uri", null)
      order                  = lookup(var.vmss.gallery_application, "order", null)
      tag                    = lookup(var.vmss.gallery_application, "tag", null)
    }
  }

  dynamic "identity" {
    for_each = [lookup(var.vmss, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity[var.vmss.name].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
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

  dynamic "plan" {
    for_each = lookup(var.vmss, "plan", null) != null ? [1] : []

    content {
      name      = lookup(var.vmss.plan, "name", null)
      publisher = lookup(var.vmss.plan, "publisher", null)
      product   = lookup(var.vmss.plan, "product", null)
    }
  }


  dynamic "rolling_upgrade_policy" {
    for_each = lookup(var.vmss, "rolling_upgrade_policy", null) != null ? [1] : []

    content {
      cross_zone_upgrades_enabled             = lookup(var.vmss.rolling_upgrade_policy, "cross_zone_upgrades_enabled", null)
      max_batch_instance_percent              = lookup(var.vmss.rolling_upgrade_policy, "max_batch_instance_percent", null)
      max_unhealthy_instance_percent          = lookup(var.vmss.rolling_upgrade_policy, "max_unhealthy_instance_percent", null)
      max_unhealthy_upgraded_instance_percent = lookup(var.vmss.rolling_upgrade_policy, "max_unhealthy_upgraded_instance_percent", null)
      pause_time_between_batches              = lookup(var.vmss.rolling_upgrade_policy, "pause_time_between_batches", null)
      prioritize_unhealthy_instances_enabled  = lookup(var.vmss.rolling_upgrade_policy, "prioritize_unhealthy_instances_enabled", null)
    }
  }


  dynamic "secret" {
    for_each = lookup(var.vmss, "secret", null) != null ? [1] : []

    content {
      key_vault_id = lookup(var.vmss.secret, "key_vault_id", null)

      dynamic "certificate" {
        for_each = try(var.vmss.secret.certificate, null) != null ? [1] : []
        content {
          store = certificate.value.store
          url   = certificate.value.url
        }
      }
    }
  }

  dynamic "scale_in" {
    for_each = lookup(var.vmss, "scale_in", null) != null ? [1] : []

    content {
      rule                   = lookup(var.vmss.scale_in, "rule", null)
      force_deletion_enabled = lookup(var.vmss.scale_in, "force_deletion_enabled", null)
    }
  }

  dynamic "spot_restore" {
    for_each = lookup(var.vmss, "spot_restore", null) != null ? [1] : []

    content {
      enabled = true
      timeout = lookup(var.vmss, "timeout", "PT1H")
    }
  }

  dynamic "termination_notification" {
    for_each = lookup(var.vmss, "termination_notification", null) != null ? [1] : []

    content {
      enabled = true
      timeout = lookup(var.vmss.termination_notification, "timeout", "PT5M")
    }
  }

  dynamic "winrm_listener" {
    for_each = lookup(var.vmss, "winrm_listener", null) != null ? [1] : []

    content {
      certificate_url = lookup(var.vmss.winrm_listener, "certificate_url", null)
      protocol        = lookup(var.vmss.winrm_listener, "protocol", null)
    }
  }

  lifecycle {
    ignore_changes = [instances]
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "ext" {
  for_each = local.ext_keys

  name                         = each.value.name
  virtual_machine_scale_set_id = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[each.value.vmss_name].id : azurerm_windows_virtual_machine_scale_set.vmss[each.value.vmss_name].id
  publisher                    = each.value.publisher
  type                         = each.value.type
  type_handler_version         = each.value.type_handler_version
  auto_upgrade_minor_version   = each.value.auto_upgrade_minor_version
  settings                     = jsonencode(each.value.settings)
  protected_settings           = jsonencode(each.value.protected_settings)
}

# autoscaling
resource "azurerm_monitor_autoscale_setting" "scaling" {
  for_each = try(var.vmss.autoscaling, null) != null ? { (var.vmss.name) = var.vmss.autoscaling } : {}

  name                = "scaler"
  resource_group_name = var.vmss.resource_group
  location            = var.vmss.location
  target_resource_id  = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.name].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.name].id
  tags                = try(var.vmss.tags, var.tags, null)

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
          metric_resource_id = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.name].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.name].id
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

# user assigned identity
resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(
    ["UserAssigned", "SystemAssigned, UserAssigned"], try(var.vmss.identity.type, "")
  ) ? { (var.vmss.name) = {} } : {}


  name                = try(var.vmss.identity.name, "uai-${var.vmss.name}")
  resource_group_name = coalesce(lookup(var.vmss, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.vmss, "location", null), var.location)
  tags                = try(var.vmss.tags, var.tags, null)
}
