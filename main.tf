data "azurerm_subscription" "current" {}

# scale set linux
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  for_each = var.vmss.type == "linux" ? {
    (var.vmss.name) = true
  } : {}

  resource_group_name = coalesce(
    lookup(
      var.vmss, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.vmss, "location", null
    ), var.location
  )

  name                                              = var.vmss.name
  sku                                               = var.vmss.sku
  instances                                         = var.vmss.instances
  admin_username                                    = var.vmss.admin_username
  admin_password                                    = var.vmss.admin_password
  upgrade_mode                                      = var.vmss.upgrade_mode
  provision_vm_agent                                = var.vmss.provision_vm_agent
  platform_fault_domain_count                       = var.vmss.platform_fault_domain_count
  priority                                          = var.vmss.priority
  secure_boot_enabled                               = var.vmss.secure_boot_enabled
  vtpm_enabled                                      = var.vmss.vtpm_enabled
  zone_balance                                      = var.vmss.zone_balance
  zones                                             = var.vmss.zones
  edge_zone                                         = var.vmss.edge_zone
  encryption_at_host_enabled                        = var.vmss.encryption_at_host_enabled
  extension_operations_enabled                      = var.vmss.extension_operations_enabled
  extensions_time_budget                            = var.vmss.extensions_time_budget
  overprovision                                     = var.vmss.overprovision
  capacity_reservation_group_id                     = var.vmss.capacity_reservation_group_id
  computer_name_prefix                              = coalesce(var.vmss.computer_name_prefix, var.vmss.name)
  custom_data                                       = var.vmss.custom_data
  do_not_run_extensions_on_overprovisioned_machines = var.vmss.do_not_run_extensions_on_overprovisioned_machines
  eviction_policy                                   = var.vmss.eviction_policy
  health_probe_id                                   = var.vmss.health_probe_id
  host_group_id                                     = var.vmss.host_group_id
  max_bid_price                                     = var.vmss.max_bid_price
  proximity_placement_group_id                      = var.vmss.proximity_placement_group_id
  single_placement_group                            = var.vmss.single_placement_group
  source_image_id                                   = var.vmss.source_image_id
  user_data                                         = var.vmss.user_data
  tags                                              = coalesce(var.vmss.tags, var.tags)

  disable_password_authentication = (
    try(var.vmss.password, null) != null ? false : try(var.vmss.public_key, null) != null ||
    contains(keys(tls_private_key.tls_key), var.vmss.name) ? true : try(var.vmss.disable_password_authentication, true)
  )

  dynamic "source_image_reference" {
    for_each = try(var.vmss.source_image_id, null) == null ? [true] : []

    content {
      publisher = try(
        var.vmss.source_image_reference.publisher, var.source_image_reference != null ? var.source_image_reference.publisher : null
      )
      offer = try(
        var.vmss.source_image_reference.offer, var.source_image_reference != null ? var.source_image_reference.offer : null
      )
      sku = try(
        var.vmss.source_image_reference.sku, var.source_image_reference != null ? var.source_image_reference.sku : null
      )
      version = try(
        var.vmss.source_image_reference.version, var.source_image_reference != null ? var.source_image_reference.version : null
      )
    }
  }

  os_disk {
    storage_account_type             = var.vmss.os_disk.storage_account_type
    caching                          = var.vmss.os_disk.caching
    disk_encryption_set_id           = var.vmss.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.vmss.os_disk.disk_size_gb
    secure_vm_disk_encryption_set_id = var.vmss.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.vmss.os_disk.security_encryption_type
    write_accelerator_enabled        = var.vmss.os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.vmss.diff_disk_settings != null ? [1] : []

      content {
        option    = var.vmss.diff_disk_settings.option
        placement = var.vmss.diff_disk_settings.placement
      }
    }
  }



  dynamic "additional_capabilities" {
    for_each = try(var.vmss.additional_capabilities, null) != null ? [1] : []

    content {
      ultra_ssd_enabled = var.vmss.additional_capabilities.ultra_ssd_enabled
    }
  }

  dynamic "admin_ssh_key" {
    for_each = try(var.vmss.public_key, null) != null || contains(keys(tls_private_key.tls_key), var.vmss.name) ? [1] : []

    content {
      username   = var.vmss.username
      public_key = try(var.vmss.public_key, null) != null ? var.vmss.public_key : tls_private_key.tls_key[var.vmss.name].public_key_openssh
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.vmss.automatic_instance_repair != null ? [1] : []

    content {
      enabled      = var.vmss.automatic_instance_repair.enabled
      grace_period = var.vmss.automatic_instance_repair.grace_period
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.vmss.automatic_os_upgrade_policy != null ? [1] : []

    content {
      disable_automatic_rollback  = var.vmss.automatic_os_upgrade_policy.disable_automatic_rollback
      enable_automatic_os_upgrade = var.vmss.automatic_os_upgrade_policy.enable_automatic_os_upgrade
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.vmss, "boot_diagnostics", null) != null ? [1] : []

    content {
      storage_account_uri = lookup(
        var.vmss.boot_diagnostics, "storage_account_uri", null
      )
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
    for_each = try(
      var.vmss.gallery_applications, {}
    )

    content {
      tag                    = gallery_application.value.tag
      order                  = gallery_application.value.order
      version_id             = gallery_application.value.version_id
      configuration_blob_uri = gallery_application.value.configuration_blob_uri
    }
  }

  dynamic "identity" {
    for_each = lookup(var.vmss, "identity", null) != null ? [var.vmss.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
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
    for_each = var.vmss.plan != null ? [1] : []

    content {
      name      = var.vmss.plan.name
      publisher = var.vmss.plan.publisher
      product   = var.vmss.plan.product
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.vmss.rolling_upgrade_policy != null ? [1] : []

    content {
      cross_zone_upgrades_enabled             = var.vmss.rolling_upgrade_policy.cross_zone_upgrades_enabled
      max_batch_instance_percent              = var.vmss.rolling_upgrade_policy.max_batch_instance_percent
      max_unhealthy_instance_percent          = var.vmss.rolling_upgrade_policy.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = var.vmss.rolling_upgrade_policy.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = var.vmss.rolling_upgrade_policy.pause_time_between_batches
      prioritize_unhealthy_instances_enabled  = var.vmss.rolling_upgrade_policy.prioritize_unhealthy_instances_enabled
    }
  }

  dynamic "scale_in" {
    for_each = var.vmss.scale_in != null ? [1] : []

    content {
      rule                   = var.vmss.scale_in.rule
      force_deletion_enabled = var.vmss.scale_in.force_deletion_enabled
    }
  }

  dynamic "secret" {
    for_each = try(
      var.vmss.secrets, {}
    )

    content {
      key_vault_id = secret.value.key_vault_id

      certificate {
        url = secret.value.certificate.url
      }
    }
  }

  dynamic "spot_restore" {
    for_each = var.vmss.spot_restore != null ? [1] : []

    content {
      enabled = var.vmss.spot_restore.enabled
      timeout = var.vmss.spot_restore.timeout
    }
  }

  dynamic "termination_notification" {
    for_each = try(var.vmss.termination_notification, null) != null ? [1] : []

    content {
      enabled = var.vmss.termination_notification.enabled
      timeout = var.vmss.termination_notification.timeout
    }
  }

  lifecycle {
    ignore_changes = [instances]
  }
}

# secrets
resource "tls_private_key" "tls_key" {
  for_each = var.vmss.type == "linux" && try(var.vmss.generate_ssh_key.enable, false) == true ? { (var.vmss.name) = true } : {}

  algorithm   = var.vmss.generate_ssh_key.algorithm
  rsa_bits    = var.vmss.generate_ssh_key.rsa_bits
  ecdsa_curve = var.vmss.generate_ssh_key.ecdsa_curve
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.vmss.type == "linux" && try(var.vmss.generate_ssh_key.enable, false) == true ? { (var.vmss.name) = true } : {}

  name             = format("%s-%s-%s", "kvs", var.vmss.name, "pub")
  value            = tls_private_key.tls_key[var.vmss.name].public_key_openssh
  key_vault_id     = var.keyvault
  expiration_date  = var.vmss.generate_ssh_key.expiration_date
  not_before_date  = var.vmss.generate_ssh_key.not_before_date
  value_wo_version = var.vmss.generate_ssh_key.value_wo_version
  value_wo         = var.vmss.generate_ssh_key.value_wo
  content_type     = var.vmss.generate_ssh_key.content_type

  tags = coalesce(
    var.vmss.tags, var.tags
  )
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.vmss.type == "linux" && try(var.vmss.generate_ssh_key.enable, false) == true ? { (var.vmss.name) = true } : {}

  name             = format("%s-%s-%s", "kvs", var.vmss.name, "priv")
  value            = tls_private_key.tls_key[var.vmss.name].private_key_pem
  key_vault_id     = var.keyvault
  expiration_date  = var.vmss.generate_ssh_key.expiration_date
  not_before_date  = var.vmss.generate_ssh_key.not_before_date
  value_wo         = var.vmss.generate_ssh_key.value_wo
  value_wo_version = var.vmss.generate_ssh_key.value_wo_version
  content_type     = var.vmss.generate_ssh_key.content_type

  tags = coalesce(
    var.vmss.tags, var.tags
  )
}

resource "random_password" "password" {
  for_each = var.vmss.type == "windows" && var.vmss.admin_password == null ? { (var.vmss.name) = true } : {}

  length      = var.vmss.generate_password.length
  special     = var.vmss.generate_password.special
  min_lower   = var.vmss.generate_password.min_lower
  min_upper   = var.vmss.generate_password.min_upper
  min_special = var.vmss.generate_password.min_special
  min_numeric = var.vmss.generate_password.min_numeric
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.vmss.type == "windows" && var.vmss.admin_password == null ? { (var.vmss.name) = true } : {}

  name         = format("%s-%s", "kvs", var.vmss.name)
  value        = random_password.password[var.vmss.name].result
  key_vault_id = var.keyvault
  tags         = coalesce(var.vmss.tags, var.tags)
}

# scale set windows
resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  for_each = var.vmss.type == "windows" ? {
    (var.vmss.name) = true
  } : {}
  name = var.vmss.name
  resource_group_name = coalesce(
    lookup(
      var.vmss, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.vmss, "location", null
    ), var.location
  )

  admin_password = var.vmss.admin_password != null ? var.vmss.admin_password : azurerm_key_vault_secret.secret[var.vmss.name].value

  sku                                               = var.vmss.sku
  instances                                         = var.vmss.instances
  admin_username                                    = var.vmss.admin_username
  upgrade_mode                                      = var.vmss.upgrade_mode
  provision_vm_agent                                = var.vmss.provision_vm_agent
  platform_fault_domain_count                       = var.vmss.platform_fault_domain_count
  priority                                          = var.vmss.priority
  secure_boot_enabled                               = var.vmss.secure_boot_enabled
  vtpm_enabled                                      = var.vmss.vtpm_enabled
  zone_balance                                      = var.vmss.zone_balance
  zones                                             = var.vmss.zones
  edge_zone                                         = var.vmss.edge_zone
  encryption_at_host_enabled                        = var.vmss.encryption_at_host_enabled
  extension_operations_enabled                      = var.vmss.extension_operations_enabled
  extensions_time_budget                            = var.vmss.extensions_time_budget
  overprovision                                     = var.vmss.overprovision
  capacity_reservation_group_id                     = var.vmss.capacity_reservation_group_id
  computer_name_prefix                              = coalesce(var.vmss.computer_name_prefix, var.vmss.name)
  custom_data                                       = var.vmss.custom_data
  do_not_run_extensions_on_overprovisioned_machines = var.vmss.do_not_run_extensions_on_overprovisioned_machines
  eviction_policy                                   = var.vmss.eviction_policy
  health_probe_id                                   = var.vmss.health_probe_id
  host_group_id                                     = var.vmss.host_group_id
  max_bid_price                                     = var.vmss.max_bid_price
  proximity_placement_group_id                      = var.vmss.proximity_placement_group_id
  single_placement_group                            = var.vmss.single_placement_group
  source_image_id                                   = var.vmss.source_image_id
  user_data                                         = var.vmss.user_data
  tags                                              = coalesce(var.vmss.tags, var.tags)

  dynamic "source_image_reference" {
    for_each = try(var.vmss.source_image_id, null) == null ? [true] : []

    content {
      publisher = try(
        var.vmss.source_image_reference.publisher, var.source_image_reference != null ? var.source_image_reference.publisher : null
      )
      offer = try(
        var.vmss.source_image_reference.offer, var.source_image_reference != null ? var.source_image_reference.offer : null
      )
      sku = try(
        var.vmss.source_image_reference.sku, var.source_image_reference != null ? var.source_image_reference.sku : null
      )
      version = try(
        var.vmss.source_image_reference.version, var.source_image_reference != null ? var.source_image_reference.version : null
      )
    }
  }
  os_disk {
    storage_account_type             = var.vmss.os_disk.storage_account_type
    caching                          = var.vmss.os_disk.caching
    disk_encryption_set_id           = var.vmss.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.vmss.os_disk.disk_size_gb
    secure_vm_disk_encryption_set_id = var.vmss.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.vmss.os_disk.security_encryption_type
    write_accelerator_enabled        = var.vmss.os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.vmss.diff_disk_settings != null ? [1] : []

      content {
        option    = var.vmss.diff_disk_settings.option
        placement = var.vmss.diff_disk_settings.placement
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = try(var.vmss.additional_capabilities, null) != null ? [1] : []

    content {
      ultra_ssd_enabled = var.vmss.additional_capabilities.ultra_ssd_enabled
    }
  }

  dynamic "additional_unattend_content" {
    for_each = var.vmss.additional_unattend_content != null ? [1] : []

    content {
      content = var.vmss.additional_unattend_content.content
      setting = var.vmss.additional_unattend_content.setting
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.vmss.automatic_os_upgrade_policy != null ? [1] : []

    content {
      disable_automatic_rollback  = var.vmss.automatic_os_upgrade_policy.disable_automatic_rollback
      enable_automatic_os_upgrade = var.vmss.automatic_os_upgrade_policy.enable_automatic_os_upgrade
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.vmss.automatic_instance_repair != null ? [1] : []

    content {
      enabled      = var.vmss.automatic_instance_repair.enabled
      grace_period = var.vmss.automatic_instance_repair.grace_period
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.vmss, "boot_diagnostics", null) != null ? [1] : []

    content {
      storage_account_uri = lookup(
        var.vmss.boot_diagnostics, "storage_account_uri", null
      )
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
    for_each = try(
      var.vmss.gallery_applications, {}
    )

    content {
      tag                    = gallery_application.value.tag
      order                  = gallery_application.value.order
      version_id             = gallery_application.value.version_id
      configuration_blob_uri = gallery_application.value.configuration_blob_uri
    }
  }

  dynamic "identity" {
    for_each = lookup(var.vmss, "identity", null) != null ? [var.vmss.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
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
    for_each = try(var.vmss.plan, null) != null ? [1] : []

    content {
      name      = var.vmss.plan.name
      product   = var.vmss.plan.product
      publisher = var.vmss.plan.publisher
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.vmss.rolling_upgrade_policy != null ? [1] : []

    content {
      cross_zone_upgrades_enabled             = var.vmss.rolling_upgrade_policy.cross_zone_upgrades_enabled
      max_batch_instance_percent              = var.vmss.rolling_upgrade_policy.max_batch_instance_percent
      max_unhealthy_instance_percent          = var.vmss.rolling_upgrade_policy.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = var.vmss.rolling_upgrade_policy.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = var.vmss.rolling_upgrade_policy.pause_time_between_batches
      prioritize_unhealthy_instances_enabled  = var.vmss.rolling_upgrade_policy.prioritize_unhealthy_instances_enabled
    }
  }
  dynamic "secret" {
    for_each = try(
      var.vmss.secrets, {}
    )

    content {
      key_vault_id = secret.value.key_vault_id

      certificate {
        url   = secret.value.certificate.url
        store = secret.value.certificate.store
      }
    }
  }

  dynamic "scale_in" {
    for_each = var.vmss.scale_in != null ? [1] : []

    content {
      rule                   = var.vmss.scale_in.rule
      force_deletion_enabled = var.vmss.scale_in.force_deletion_enabled
    }
  }

  dynamic "spot_restore" {
    for_each = var.vmss.spot_restore != null ? [1] : []

    content {
      enabled = var.vmss.spot_restore.enabled
      timeout = var.vmss.spot_restore.timeout
    }
  }

  dynamic "termination_notification" {
    for_each = try(var.vmss.termination_notification, null) != null ? [1] : []

    content {
      enabled = var.vmss.termination_notification.enabled
      timeout = var.vmss.termination_notification.timeout
    }
  }

  dynamic "winrm_listener" {
    for_each = var.vmss.winrm_listener != null ? [1] : []

    content {
      certificate_url = var.vmss.winrm_listener.certificate_url
      protocol        = var.vmss.winrm_listener.protocol
    }
  }

  lifecycle {
    ignore_changes = [instances]
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "ext" {
  for_each = length(lookup(var.vmss, "extensions", {})) > 0 ? {
    for ext_key, ext in lookup(var.vmss, "extensions", {}) :
    "${var.vmss.name}-${ext_key}" => ext
  } : {}

  name                         = lookup(each.value, "name", null) != null ? each.value.name : element(split("-", each.key), length(split("-", each.key)) - 1)
  virtual_machine_scale_set_id = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.name].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.name].id
  publisher                    = each.value.publisher
  type                         = each.value.type
  type_handler_version         = each.value.type_handler_version
  auto_upgrade_minor_version   = each.value.auto_upgrade_minor_version
  settings                     = jsonencode(each.value.settings)
  protected_settings           = jsonencode(each.value.protected_settings)

  force_update_tag            = each.value.force_update_tag
  provision_after_extensions  = each.value.provision_after_extensions
  failure_suppression_enabled = each.value.failure_suppression_enabled
  automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled

  dynamic "protected_settings_from_key_vault" {
    for_each = try(each.value.protected_settings_from_key_vault, null) != null ? [1] : []

    content {
      secret_url      = protected_settings_from_key_vault.value.secret_url
      source_vault_id = protected_settings_from_key_vault.value.source_vault_id
    }
  }
}

# autoscaling
resource "azurerm_monitor_autoscale_setting" "scaling" {
  for_each = var.vmss.autoscaling != null ? { (var.vmss.name) = var.vmss.autoscaling } : {}

  name = "scaler"
  resource_group_name = coalesce(
    var.vmss.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.vmss.location, var.location
  )
  target_resource_id = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.name].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.name].id
  tags               = coalesce(var.vmss.tags, var.tags)

  profile {
    name = "default"
    capacity {
      default = var.vmss.autoscaling.default
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
