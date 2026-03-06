# scale set linux
resource "azurerm_linux_virtual_machine_scale_set" "this" {
  for_each = var.instance.type == "linux" ? { "vmss" = true } : {}

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  name                                              = var.instance.name
  sku                                               = var.instance.sku
  instances                                         = var.instance.instances
  admin_username                                    = var.instance.admin_username
  admin_password                                    = var.instance.admin_password
  upgrade_mode                                      = var.instance.upgrade_mode
  provision_vm_agent                                = var.instance.provision_vm_agent
  platform_fault_domain_count                       = var.instance.platform_fault_domain_count
  priority                                          = var.instance.priority
  resilient_vm_creation_enabled                     = var.instance.resilient_vm_creation_enabled
  resilient_vm_deletion_enabled                     = var.instance.resilient_vm_deletion_enabled
  secure_boot_enabled                               = var.instance.secure_boot_enabled
  vtpm_enabled                                      = var.instance.vtpm_enabled
  zone_balance                                      = var.instance.zone_balance
  zones                                             = var.instance.zones
  edge_zone                                         = var.instance.edge_zone
  encryption_at_host_enabled                        = var.instance.encryption_at_host_enabled
  extension_operations_enabled                      = var.instance.extension_operations_enabled
  extensions_time_budget                            = var.instance.extensions_time_budget
  overprovision                                     = var.instance.overprovision
  capacity_reservation_group_id                     = var.instance.capacity_reservation_group_id
  custom_data                                       = var.instance.custom_data
  do_not_run_extensions_on_overprovisioned_machines = var.instance.do_not_run_extensions_on_overprovisioned_machines
  eviction_policy                                   = var.instance.eviction_policy
  health_probe_id                                   = var.instance.health_probe_id
  host_group_id                                     = var.instance.host_group_id
  max_bid_price                                     = var.instance.max_bid_price
  proximity_placement_group_id                      = var.instance.proximity_placement_group_id
  single_placement_group                            = var.instance.single_placement_group
  source_image_id                                   = var.instance.source_image_id
  user_data                                         = var.instance.user_data

  computer_name_prefix = coalesce(
    var.instance.computer_name_prefix, var.instance.name
  )

  tags = coalesce(
    var.instance.tags, var.tags
  )

  disable_password_authentication = (
    var.instance.admin_password != null ? false : var.instance.public_key != null ? true : var.instance.disable_password_authentication
  )

  dynamic "source_image_reference" {
    for_each = var.instance.source_image_id == null ? [true] : []

    content {
      publisher = try(
        var.instance.source_image_reference.publisher, var.source_image_reference != null ? var.source_image_reference.publisher : null
      )
      offer = try(
        var.instance.source_image_reference.offer, var.source_image_reference != null ? var.source_image_reference.offer : null
      )
      sku = try(
        var.instance.source_image_reference.sku, var.source_image_reference != null ? var.source_image_reference.sku : null
      )
      version = try(
        var.instance.source_image_reference.version, var.source_image_reference != null ? var.source_image_reference.version : null
      )
    }
  }

  os_disk {
    storage_account_type             = var.instance.os_disk.storage_account_type
    caching                          = var.instance.os_disk.caching
    disk_encryption_set_id           = var.instance.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.instance.os_disk.disk_size_gb
    secure_vm_disk_encryption_set_id = var.instance.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.instance.os_disk.security_encryption_type
    write_accelerator_enabled        = var.instance.os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.instance.diff_disk_settings != null ? [var.instance.diff_disk_settings] : []

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.instance.additional_capabilities != null ? [var.instance.additional_capabilities] : []

    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.instance.public_key != null ? [1] : []

    content {
      username   = var.instance.username
      public_key = var.instance.public_key
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.instance.automatic_instance_repair != null ? [var.instance.automatic_instance_repair] : []

    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.instance.automatic_os_upgrade_policy != null ? [var.instance.automatic_os_upgrade_policy] : []

    content {
      disable_automatic_rollback  = automatic_os_upgrade_policy.value.disable_automatic_rollback
      enable_automatic_os_upgrade = automatic_os_upgrade_policy.value.enable_automatic_os_upgrade
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.instance, "boot_diagnostics", null) != null ? [var.instance.boot_diagnostics] : []

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "data_disk" {
    for_each = var.instance.disks

    content {
      name = coalesce(
        data_disk.value.name,
        lookup(var.naming, "managed_disk", null) != null ? join("-", [var.naming.managed_disk, data_disk.key]) : null
      )

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
      var.instance.gallery_applications, {}
    )

    content {
      tag                    = gallery_application.value.tag
      order                  = gallery_application.value.order
      version_id             = gallery_application.value.version_id
      configuration_blob_uri = gallery_application.value.configuration_blob_uri
    }
  }

  dynamic "identity" {
    for_each = lookup(var.instance, "identity", null) != null ? [var.instance.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_interface" {
    for_each = var.instance.interfaces

    content {
      name                          = "nic-${network_interface.key}"
      primary                       = network_interface.value.primary
      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      enable_ip_forwarding          = network_interface.value.enable_ip_forwarding
      auxiliary_mode                = network_interface.value.auxiliary_mode
      auxiliary_sku                 = network_interface.value.auxiliary_sku
      network_security_group_id     = network_interface.value.network_security_group_id

      ip_configuration {
        name                                         = "ipconf-${network_interface.key}"
        primary                                      = network_interface.value.primary
        subnet_id                                    = network_interface.value.subnet
        application_gateway_backend_address_pool_ids = network_interface.value.application_gateway_backend_address_pool_ids
        application_security_group_ids               = network_interface.value.application_security_group_ids
        load_balancer_backend_address_pool_ids       = network_interface.value.load_balancer_backend_address_pool_ids
        load_balancer_inbound_nat_rules_ids          = network_interface.value.load_balancer_inbound_nat_rules_ids
        version                                      = network_interface.value.ip_configuration != null ? network_interface.value.ip_configuration.version : null

        dynamic "public_ip_address" {
          for_each = network_interface.value.public_ip_address != null ? [network_interface.value.public_ip_address] : []

          content {
            name                    = public_ip_address.value.name != null ? public_ip_address.value.name : "pip-${network_interface.key}"
            idle_timeout_in_minutes = public_ip_address.value.idle_timeout_in_minutes
            domain_name_label       = public_ip_address.value.domain_name_label
            public_ip_prefix_id     = public_ip_address.value.public_ip_prefix_id
            version                 = public_ip_address.value.version

            dynamic "ip_tag" {
              for_each = try(
                public_ip_address.value.ip_tags, {}
              )

              content {
                tag  = ip_tag.value.tag
                type = ip_tag.value.type
              }
            }
          }
        }
      }
    }
  }

  dynamic "plan" {
    for_each = var.instance.plan != null ? [var.instance.plan] : []

    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.instance.rolling_upgrade_policy != null ? [var.instance.rolling_upgrade_policy] : []

    content {
      cross_zone_upgrades_enabled             = rolling_upgrade_policy.value.cross_zone_upgrades_enabled
      max_batch_instance_percent              = rolling_upgrade_policy.value.max_batch_instance_percent
      max_unhealthy_instance_percent          = rolling_upgrade_policy.value.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = rolling_upgrade_policy.value.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = rolling_upgrade_policy.value.pause_time_between_batches
      prioritize_unhealthy_instances_enabled  = rolling_upgrade_policy.value.prioritize_unhealthy_instances_enabled
      maximum_surge_instances_enabled         = rolling_upgrade_policy.value.maximum_surge_instances_enabled
    }
  }

  dynamic "scale_in" {
    for_each = var.instance.scale_in != null ? [var.instance.scale_in] : []

    content {
      rule                   = scale_in.value.rule
      force_deletion_enabled = scale_in.value.force_deletion_enabled
    }
  }

  dynamic "secret" {
    for_each = try(
      var.instance.secrets, {}
    )

    content {
      key_vault_id = secret.value.key_vault_id

      certificate {
        url = secret.value.certificate.url
      }
    }
  }

  dynamic "spot_restore" {
    for_each = var.instance.spot_restore != null ? [var.instance.spot_restore] : []

    content {
      enabled = spot_restore.value.enabled
      timeout = spot_restore.value.timeout
    }
  }

  dynamic "termination_notification" {
    for_each = var.instance.termination_notification != null ? [var.instance.termination_notification] : []

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  lifecycle {
    ignore_changes = [instances, extension]
  }
}

# scale set windows
resource "azurerm_windows_virtual_machine_scale_set" "this" {
  for_each = var.instance.type == "windows" ? { "vmss" = true } : {}

  name = var.instance.name
  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  admin_password                                    = var.instance.admin_password
  enable_automatic_updates                          = var.instance.enable_automatic_updates
  license_type                                      = var.instance.license_type
  timezone                                          = var.instance.timezone
  sku                                               = var.instance.sku
  instances                                         = var.instance.instances
  admin_username                                    = var.instance.admin_username
  upgrade_mode                                      = var.instance.upgrade_mode
  provision_vm_agent                                = var.instance.provision_vm_agent
  platform_fault_domain_count                       = var.instance.platform_fault_domain_count
  priority                                          = var.instance.priority
  resilient_vm_creation_enabled                     = var.instance.resilient_vm_creation_enabled
  resilient_vm_deletion_enabled                     = var.instance.resilient_vm_deletion_enabled
  secure_boot_enabled                               = var.instance.secure_boot_enabled
  vtpm_enabled                                      = var.instance.vtpm_enabled
  zone_balance                                      = var.instance.zone_balance
  zones                                             = var.instance.zones
  edge_zone                                         = var.instance.edge_zone
  encryption_at_host_enabled                        = var.instance.encryption_at_host_enabled
  extension_operations_enabled                      = var.instance.extension_operations_enabled
  extensions_time_budget                            = var.instance.extensions_time_budget
  overprovision                                     = var.instance.overprovision
  capacity_reservation_group_id                     = var.instance.capacity_reservation_group_id
  custom_data                                       = var.instance.custom_data
  do_not_run_extensions_on_overprovisioned_machines = var.instance.do_not_run_extensions_on_overprovisioned_machines
  eviction_policy                                   = var.instance.eviction_policy
  health_probe_id                                   = var.instance.health_probe_id
  host_group_id                                     = var.instance.host_group_id
  max_bid_price                                     = var.instance.max_bid_price
  proximity_placement_group_id                      = var.instance.proximity_placement_group_id
  single_placement_group                            = var.instance.single_placement_group
  source_image_id                                   = var.instance.source_image_id
  user_data                                         = var.instance.user_data

  computer_name_prefix = coalesce(
    var.instance.computer_name_prefix, var.instance.name
  )

  tags = coalesce(
    var.instance.tags, var.tags
  )

  dynamic "source_image_reference" {
    for_each = var.instance.source_image_id == null ? [true] : []

    content {
      publisher = try(
        var.instance.source_image_reference.publisher, var.source_image_reference != null ? var.source_image_reference.publisher : null
      )
      offer = try(
        var.instance.source_image_reference.offer, var.source_image_reference != null ? var.source_image_reference.offer : null
      )
      sku = try(
        var.instance.source_image_reference.sku, var.source_image_reference != null ? var.source_image_reference.sku : null
      )
      version = try(
        var.instance.source_image_reference.version, var.source_image_reference != null ? var.source_image_reference.version : null
      )
    }
  }

  os_disk {
    storage_account_type             = var.instance.os_disk.storage_account_type
    caching                          = var.instance.os_disk.caching
    disk_encryption_set_id           = var.instance.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.instance.os_disk.disk_size_gb
    secure_vm_disk_encryption_set_id = var.instance.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.instance.os_disk.security_encryption_type
    write_accelerator_enabled        = var.instance.os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.instance.diff_disk_settings != null ? [var.instance.diff_disk_settings] : []

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.instance.additional_capabilities != null ? [var.instance.additional_capabilities] : []

    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  dynamic "additional_unattend_content" {
    for_each = var.instance.additional_unattend_content != null ? [var.instance.additional_unattend_content] : []

    content {
      content = additional_unattend_content.value.content
      setting = additional_unattend_content.value.setting
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.instance.automatic_os_upgrade_policy != null ? [var.instance.automatic_os_upgrade_policy] : []

    content {
      disable_automatic_rollback  = automatic_os_upgrade_policy.value.disable_automatic_rollback
      enable_automatic_os_upgrade = automatic_os_upgrade_policy.value.enable_automatic_os_upgrade
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.instance.automatic_instance_repair != null ? [var.instance.automatic_instance_repair] : []

    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.instance, "boot_diagnostics", null) != null ? [var.instance.boot_diagnostics] : []

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "data_disk" {
    for_each = var.instance.disks

    content {
      name = coalesce(
        data_disk.value.name,
        lookup(var.naming, "managed_disk", null) != null ? join("-", [var.naming.managed_disk, data_disk.key]) : null
      )

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
      var.instance.gallery_applications, {}
    )

    content {
      tag                    = gallery_application.value.tag
      order                  = gallery_application.value.order
      version_id             = gallery_application.value.version_id
      configuration_blob_uri = gallery_application.value.configuration_blob_uri
    }
  }

  dynamic "identity" {
    for_each = lookup(var.instance, "identity", null) != null ? [var.instance.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_interface" {
    for_each = var.instance.interfaces

    content {
      name                          = "nic-${network_interface.key}"
      primary                       = network_interface.value.primary
      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      enable_ip_forwarding          = network_interface.value.enable_ip_forwarding
      auxiliary_mode                = network_interface.value.auxiliary_mode
      auxiliary_sku                 = network_interface.value.auxiliary_sku
      network_security_group_id     = network_interface.value.network_security_group_id

      ip_configuration {
        name                                         = "ipconf-${network_interface.key}"
        primary                                      = network_interface.value.primary
        subnet_id                                    = network_interface.value.subnet
        application_gateway_backend_address_pool_ids = network_interface.value.application_gateway_backend_address_pool_ids
        application_security_group_ids               = network_interface.value.application_security_group_ids
        load_balancer_backend_address_pool_ids       = network_interface.value.load_balancer_backend_address_pool_ids
        load_balancer_inbound_nat_rules_ids          = network_interface.value.load_balancer_inbound_nat_rules_ids
        version                                      = network_interface.value.ip_configuration != null ? network_interface.value.ip_configuration.version : null

        dynamic "public_ip_address" {
          for_each = network_interface.value.public_ip_address != null ? [network_interface.value.public_ip_address] : []

          content {
            name                    = public_ip_address.value.name != null ? public_ip_address.value.name : "pip-${network_interface.key}"
            idle_timeout_in_minutes = public_ip_address.value.idle_timeout_in_minutes
            domain_name_label       = public_ip_address.value.domain_name_label
            public_ip_prefix_id     = public_ip_address.value.public_ip_prefix_id
            version                 = public_ip_address.value.version

            dynamic "ip_tag" {
              for_each = try(
                public_ip_address.value.ip_tags, {}
              )

              content {
                tag  = ip_tag.value.tag
                type = ip_tag.value.type
              }
            }
          }
        }
      }
    }
  }

  dynamic "plan" {
    for_each = var.instance.plan != null ? [1] : []

    content {
      name      = var.instance.plan.name
      product   = var.instance.plan.product
      publisher = var.instance.plan.publisher
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.instance.rolling_upgrade_policy != null ? [var.instance.rolling_upgrade_policy] : []

    content {
      cross_zone_upgrades_enabled             = rolling_upgrade_policy.value.cross_zone_upgrades_enabled
      max_batch_instance_percent              = rolling_upgrade_policy.value.max_batch_instance_percent
      max_unhealthy_instance_percent          = rolling_upgrade_policy.value.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = rolling_upgrade_policy.value.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = rolling_upgrade_policy.value.pause_time_between_batches
      prioritize_unhealthy_instances_enabled  = rolling_upgrade_policy.value.prioritize_unhealthy_instances_enabled
      maximum_surge_instances_enabled         = rolling_upgrade_policy.value.maximum_surge_instances_enabled
    }
  }
  dynamic "secret" {
    for_each = try(
      var.instance.secrets, {}
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
    for_each = var.instance.scale_in != null ? [var.instance.scale_in] : []

    content {
      rule                   = scale_in.value.rule
      force_deletion_enabled = scale_in.value.force_deletion_enabled
    }
  }

  dynamic "spot_restore" {
    for_each = var.instance.spot_restore != null ? [var.instance.spot_restore] : []

    content {
      enabled = spot_restore.value.enabled
      timeout = spot_restore.value.timeout
    }
  }

  dynamic "termination_notification" {
    for_each = var.instance.termination_notification != null ? [var.instance.termination_notification] : []

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  dynamic "winrm_listener" {
    for_each = var.instance.winrm_listener != null ? [var.instance.winrm_listener] : []

    content {
      certificate_url = winrm_listener.value.certificate_url
      protocol        = winrm_listener.value.protocol
    }
  }

  lifecycle {
    ignore_changes = [instances, extension]
  }
}

# scale set flex (orchestrated)
resource "azurerm_orchestrated_virtual_machine_scale_set" "this" {
  for_each = var.instance.type == "flex" ? { "vmss" = true } : {}

  name = var.instance.name

  resource_group_name = coalesce(
    lookup(var.instance, "resource_group_name", null), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null), var.location
  )

  network_api_version           = var.instance.network_api_version
  platform_fault_domain_count   = var.instance.platform_fault_domain_count
  proximity_placement_group_id  = var.instance.proximity_placement_group_id
  single_placement_group        = var.instance.single_placement_group
  zone_balance                  = var.instance.zone_balance
  zones                         = var.instance.zones
  upgrade_mode                  = var.instance.upgrade_mode
  encryption_at_host_enabled    = var.instance.encryption_at_host_enabled
  extension_operations_enabled  = var.instance.extension_operations_enabled
  extensions_time_budget        = var.instance.extensions_time_budget
  capacity_reservation_group_id = var.instance.capacity_reservation_group_id
  source_image_id               = var.instance.source_image_id
  user_data_base64              = var.instance.user_data != null ? base64encode(var.instance.user_data) : null
  instances                     = var.instance.instances
  sku_name                      = var.instance.sku
  eviction_policy               = var.instance.eviction_policy
  max_bid_price                 = var.instance.max_bid_price
  priority                      = var.instance.priority
  license_type                  = var.instance.license_type

  tags = coalesce(
    var.instance.tags, var.tags
  )

  dynamic "additional_capabilities" {
    for_each = var.instance.additional_capabilities != null ? [var.instance.additional_capabilities] : []

    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.instance.automatic_instance_repair != null ? [var.instance.automatic_instance_repair] : []

    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.instance, "boot_diagnostics", null) != null ? [var.instance.boot_diagnostics] : []

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "identity" {
    for_each = lookup(var.instance, "identity", null) != null ? [var.instance.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_interface" {
    for_each = var.instance.interfaces

    content {
      name                          = "nic-${network_interface.key}"
      primary                       = network_interface.value.primary
      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      enable_ip_forwarding          = network_interface.value.enable_ip_forwarding
      auxiliary_mode                = network_interface.value.auxiliary_mode
      auxiliary_sku                 = network_interface.value.auxiliary_sku
      network_security_group_id     = network_interface.value.network_security_group_id

      ip_configuration {
        name                                         = "ipconf-${network_interface.key}"
        primary                                      = network_interface.value.primary
        subnet_id                                    = network_interface.value.subnet
        application_gateway_backend_address_pool_ids = network_interface.value.application_gateway_backend_address_pool_ids
        application_security_group_ids               = network_interface.value.application_security_group_ids
        load_balancer_backend_address_pool_ids       = network_interface.value.load_balancer_backend_address_pool_ids
        version                                      = network_interface.value.ip_configuration != null ? network_interface.value.ip_configuration.version : null

        dynamic "public_ip_address" {
          for_each = network_interface.value.public_ip_address != null ? [network_interface.value.public_ip_address] : []

          content {
            name                    = public_ip_address.value.name != null ? public_ip_address.value.name : "pip-${network_interface.key}"
            domain_name_label       = public_ip_address.value.domain_name_label
            idle_timeout_in_minutes = public_ip_address.value.idle_timeout_in_minutes
            public_ip_prefix_id     = public_ip_address.value.public_ip_prefix_id
            sku_name                = public_ip_address.value.sku_name
            version                 = public_ip_address.value.version

            dynamic "ip_tag" {
              for_each = try(public_ip_address.value.ip_tags, {})

              content {
                tag  = ip_tag.value.tag
                type = ip_tag.value.type
              }
            }
          }
        }
      }
    }
  }

  dynamic "os_disk" {
    for_each = [1]

    content {
      storage_account_type      = var.instance.os_disk.storage_account_type
      caching                   = var.instance.os_disk.caching
      disk_encryption_set_id    = var.instance.os_disk.disk_encryption_set_id
      disk_size_gb              = var.instance.os_disk.disk_size_gb
      write_accelerator_enabled = var.instance.os_disk.write_accelerator_enabled

      dynamic "diff_disk_settings" {
        for_each = var.instance.diff_disk_settings != null ? [var.instance.diff_disk_settings] : []

        content {
          option    = diff_disk_settings.value.option
          placement = diff_disk_settings.value.placement
        }
      }
    }
  }

  dynamic "os_profile" {
    for_each = var.instance.source_image_id != null || var.instance.source_image_reference != null || var.source_image_reference != null ? [1] : []

    content {
      custom_data = var.instance.custom_data != null ? base64encode(var.instance.custom_data) : null

      dynamic "linux_configuration" {
        for_each = lower(coalesce(var.instance.os_type, "linux")) == "linux" ? [1] : []

        content {
          disable_password_authentication = (
            var.instance.admin_password != null ? false : var.instance.public_key != null ? true : var.instance.disable_password_authentication
          )
          admin_username     = var.instance.admin_username
          admin_password     = var.instance.admin_password
          provision_vm_agent = var.instance.provision_vm_agent
          computer_name_prefix = coalesce(
            var.instance.computer_name_prefix, var.instance.name
          )
          patch_assessment_mode = var.instance.patch_assessment_mode
          patch_mode            = var.instance.patch_mode

          dynamic "admin_ssh_key" {
            for_each = var.instance.public_key != null ? [1] : []

            content {
              username   = var.instance.username
              public_key = var.instance.public_key
            }
          }

          dynamic "secret" {
            for_each = try(var.instance.secrets, {})

            content {
              key_vault_id = secret.value.key_vault_id

              dynamic "certificate" {
                for_each = [secret.value.certificate]

                content {
                  url = certificate.value.url
                }
              }
            }
          }
        }
      }

      dynamic "windows_configuration" {
        for_each = lower(coalesce(var.instance.os_type, "linux")) == "windows" ? [1] : []

        content {
          admin_username           = var.instance.admin_username
          admin_password           = var.instance.admin_password
          enable_automatic_updates = var.instance.enable_automatic_updates
          provision_vm_agent       = var.instance.provision_vm_agent
          timezone                 = var.instance.timezone
          computer_name_prefix = coalesce(
            var.instance.computer_name_prefix, var.instance.name
          )
          patch_assessment_mode = var.instance.patch_assessment_mode
          patch_mode            = var.instance.patch_mode
          hotpatching_enabled   = var.instance.hotpatching_enabled

          dynamic "additional_unattend_content" {
            for_each = var.instance.additional_unattend_content != null ? [var.instance.additional_unattend_content] : []

            content {
              content = additional_unattend_content.value.content
              setting = additional_unattend_content.value.setting
            }
          }

          dynamic "secret" {
            for_each = try(var.instance.secrets, {})

            content {
              key_vault_id = secret.value.key_vault_id

              dynamic "certificate" {
                for_each = [secret.value.certificate]

                content {
                  url   = certificate.value.url
                  store = certificate.value.store
                }
              }
            }
          }

          dynamic "winrm_listener" {
            for_each = var.instance.winrm_listener != null ? [var.instance.winrm_listener] : []

            content {
              certificate_url = winrm_listener.value.certificate_url
              protocol        = winrm_listener.value.protocol
            }
          }
        }
      }
    }
  }

  dynamic "data_disk" {
    for_each = var.instance.disks

    content {
      caching                        = data_disk.value.caching
      create_option                  = data_disk.value.create_option
      disk_encryption_set_id         = data_disk.value.disk_encryption_set_id
      disk_size_gb                   = data_disk.value.disk_size_gb
      lun                            = data_disk.value.lun
      storage_account_type           = data_disk.value.storage_account_type
      ultra_ssd_disk_iops_read_write = data_disk.value.ultra_ssd_disk_iops_read_write
      ultra_ssd_disk_mbps_read_write = data_disk.value.ultra_ssd_disk_mbps_read_write
      write_accelerator_enabled      = data_disk.value.write_accelerator_enabled
    }
  }

  dynamic "source_image_reference" {
    for_each = var.instance.source_image_id == null ? [true] : []

    content {
      publisher = try(
        var.instance.source_image_reference.publisher, var.source_image_reference != null ? var.source_image_reference.publisher : null
      )
      offer = try(
        var.instance.source_image_reference.offer, var.source_image_reference != null ? var.source_image_reference.offer : null
      )
      sku = try(
        var.instance.source_image_reference.sku, var.source_image_reference != null ? var.source_image_reference.sku : null
      )
      version = try(
        var.instance.source_image_reference.version, var.source_image_reference != null ? var.source_image_reference.version : null
      )
    }
  }

  dynamic "plan" {
    for_each = var.instance.plan != null ? [var.instance.plan] : []

    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }

  dynamic "priority_mix" {
    for_each = var.instance.priority == "Spot" && var.instance.priority_mix != null ? [var.instance.priority_mix] : []

    content {
      base_regular_count            = priority_mix.value.base_regular_count
      regular_percentage_above_base = priority_mix.value.regular_percentage_above_base
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.instance.rolling_upgrade_policy != null ? [var.instance.rolling_upgrade_policy] : []

    content {
      cross_zone_upgrades_enabled             = rolling_upgrade_policy.value.cross_zone_upgrades_enabled
      max_batch_instance_percent              = rolling_upgrade_policy.value.max_batch_instance_percent
      max_unhealthy_instance_percent          = rolling_upgrade_policy.value.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = rolling_upgrade_policy.value.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = rolling_upgrade_policy.value.pause_time_between_batches
      prioritize_unhealthy_instances_enabled  = rolling_upgrade_policy.value.prioritize_unhealthy_instances_enabled
      maximum_surge_instances_enabled         = rolling_upgrade_policy.value.maximum_surge_instances_enabled
    }
  }

  dynamic "sku_profile" {
    for_each = var.instance.sku_profile != null ? [var.instance.sku_profile] : []

    content {
      allocation_strategy = sku_profile.value.allocation_strategy
      vm_sizes            = sku_profile.value.vm_sizes
    }
  }

  dynamic "termination_notification" {
    for_each = var.instance.termination_notification != null ? [var.instance.termination_notification] : []

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  dynamic "extension" {
    for_each = lookup(var.instance, "extensions", {})

    content {
      name                                = lookup(extension.value, "name", extension.key)
      publisher                           = extension.value.publisher
      type                                = extension.value.type
      type_handler_version                = extension.value.type_handler_version
      settings                            = length(try(extension.value.settings, {})) > 0 ? jsonencode(extension.value.settings) : null
      protected_settings                  = length(try(extension.value.protected_settings, {})) > 0 ? jsonencode(extension.value.protected_settings) : null
      failure_suppression_enabled         = extension.value.failure_suppression_enabled
      force_extension_execution_on_change = extension.value.force_extension_execution_on_change

      dynamic "protected_settings_from_key_vault" {
        for_each = extension.value.protected_settings_from_key_vault != null ? [extension.value.protected_settings_from_key_vault] : []

        content {
          secret_url      = protected_settings_from_key_vault.value.secret_url
          source_vault_id = protected_settings_from_key_vault.value.source_vault_id
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [extension]
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "this" {
  # For Flex VMSS, extensions are defined within the VMSS resource itself so they run on individual instances.
  for_each = var.instance.type != "flex" ? try(var.instance.extensions, {}) : {}

  name                         = lookup(each.value, "name", null) != null ? each.value.name : each.key
  virtual_machine_scale_set_id = var.instance.type == "linux" ? azurerm_linux_virtual_machine_scale_set.this["vmss"].id : azurerm_windows_virtual_machine_scale_set.this["vmss"].id
  publisher                    = each.value.publisher
  type                         = each.value.type
  type_handler_version         = each.value.type_handler_version
  auto_upgrade_minor_version   = each.value.auto_upgrade_minor_version
  settings                     = length(try(each.value.settings, {})) > 0 ? jsonencode(each.value.settings) : null
  protected_settings           = length(try(each.value.protected_settings, {})) > 0 ? jsonencode(each.value.protected_settings) : null

  force_update_tag            = each.value.force_update_tag
  provision_after_extensions  = each.value.provision_after_extensions
  failure_suppression_enabled = each.value.failure_suppression_enabled
  automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled

  dynamic "protected_settings_from_key_vault" {
    for_each = each.value.protected_settings_from_key_vault != null ? [each.value.protected_settings_from_key_vault] : []

    content {
      secret_url      = protected_settings_from_key_vault.value.secret_url
      source_vault_id = protected_settings_from_key_vault.value.source_vault_id
    }
  }
}

# autoscaling
resource "azurerm_monitor_autoscale_setting" "this" {
  for_each = var.instance.autoscaling != null ? { "vmss" = var.instance.autoscaling } : {}

  name = coalesce(
    var.instance.autoscaling.name, "scaler"
  )

  resource_group_name = coalesce(
    var.instance.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.instance.location, var.location
  )

  target_resource_id = var.instance.type == "linux" ? azurerm_linux_virtual_machine_scale_set.this["vmss"].id : var.instance.type == "windows" ? azurerm_windows_virtual_machine_scale_set.this["vmss"].id : azurerm_orchestrated_virtual_machine_scale_set.this["vmss"].id
  enabled            = var.instance.autoscaling.enabled

  tags = coalesce(
    var.instance.tags, var.tags
  )

  dynamic "profile" {
    for_each = coalesce(
      var.instance.autoscaling.profiles, {}
    )

    content {
      name = profile.value.name

      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "fixed_date" {
        for_each = profile.value.fixed_date != null ? [profile.value.fixed_date] : []

        content {
          end      = fixed_date.value.end
          start    = fixed_date.value.start
          timezone = fixed_date.value.timezone
        }
      }

      dynamic "recurrence" {
        for_each = profile.value.recurrence != null ? [profile.value.recurrence] : []

        content {
          timezone = recurrence.value.timezone
          days     = recurrence.value.days
          hours    = recurrence.value.hours
          minutes  = recurrence.value.minutes
        }
      }

      dynamic "rule" {
        for_each = coalesce(
          profile.value.rules, {}
        )

        content {
          metric_trigger {
            metric_name              = rule.value.metric_trigger.metric_name
            metric_resource_id       = coalesce(try(rule.value.metric_trigger.metric_resource_id, null), var.instance.type == "linux" ? azurerm_linux_virtual_machine_scale_set.this["vmss"].id : var.instance.type == "windows" ? azurerm_windows_virtual_machine_scale_set.this["vmss"].id : azurerm_orchestrated_virtual_machine_scale_set.this["vmss"].id)
            metric_namespace         = rule.value.metric_trigger.metric_namespace
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            time_window              = rule.value.metric_trigger.time_window
            time_grain               = rule.value.metric_trigger.time_grain
            statistic                = rule.value.metric_trigger.statistic
            operator                 = rule.value.metric_trigger.operator
            threshold                = rule.value.metric_trigger.threshold
            divide_by_instance_count = rule.value.metric_trigger.divide_by_instance_count

            dynamic "dimensions" {
              for_each = coalesce(
                rule.value.metric_trigger.dimensions, []
              )

              content {
                name     = dimensions.value.name
                operator = dimensions.value.operator
                values   = dimensions.value.values
              }
            }
          }

          scale_action {
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
            cooldown  = rule.value.scale_action.cooldown
          }
        }
      }
    }
  }

  dynamic "notification" {
    for_each = var.instance.autoscaling.notification != null ? [var.instance.autoscaling.notification] : []

    content {
      dynamic "email" {
        for_each = notification.value.email != null ? [notification.value.email] : []

        content {
          custom_emails                         = email.value.custom_emails
          send_to_subscription_administrator    = email.value.send_to_subscription_administrator
          send_to_subscription_co_administrator = email.value.send_to_subscription_co_administrator
        }
      }

      dynamic "webhook" {
        for_each = try(
          notification.value.webhook, []
        )

        content {
          service_uri = webhook.value.service_uri
          properties  = webhook.value.properties
        }
      }
    }
  }

  dynamic "predictive" {
    for_each = var.instance.autoscaling.predictive != null ? [var.instance.autoscaling.predictive] : []

    content {
      scale_mode      = predictive.value.scale_mode
      look_ahead_time = predictive.value.look_ahead_time
    }
  }
}
