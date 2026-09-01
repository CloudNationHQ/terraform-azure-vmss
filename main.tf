# scale set linux
resource "azurerm_linux_virtual_machine_scale_set" "this" {
  for_each = var.virtual_machine_scale_set.type == "linux" ? { "this" = true } : {}

  resource_group_name = coalesce(
    var.virtual_machine_scale_set.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.virtual_machine_scale_set.location, var.location
  )

  name                                              = var.virtual_machine_scale_set.name
  sku                                               = var.virtual_machine_scale_set.sku
  instances                                         = var.virtual_machine_scale_set.instances
  admin_username                                    = var.virtual_machine_scale_set.admin_username
  admin_password                                    = var.virtual_machine_scale_set.admin_password
  upgrade_mode                                      = var.virtual_machine_scale_set.upgrade_mode
  provision_vm_agent                                = var.virtual_machine_scale_set.provision_vm_agent
  platform_fault_domain_count                       = var.virtual_machine_scale_set.platform_fault_domain_count
  priority                                          = var.virtual_machine_scale_set.priority
  resilient_vm_creation_enabled                     = var.virtual_machine_scale_set.resilient_vm_creation_enabled
  resilient_vm_deletion_enabled                     = var.virtual_machine_scale_set.resilient_vm_deletion_enabled
  secure_boot_enabled                               = var.virtual_machine_scale_set.secure_boot_enabled
  vtpm_enabled                                      = var.virtual_machine_scale_set.vtpm_enabled
  zone_balance                                      = var.virtual_machine_scale_set.zone_balance
  zones                                             = var.virtual_machine_scale_set.zones
  edge_zone                                         = var.virtual_machine_scale_set.edge_zone
  encryption_at_host_enabled                        = var.virtual_machine_scale_set.encryption_at_host_enabled
  extension_operations_enabled                      = var.virtual_machine_scale_set.extension_operations_enabled
  extensions_time_budget                            = var.virtual_machine_scale_set.extensions_time_budget
  overprovision                                     = var.virtual_machine_scale_set.overprovision
  capacity_reservation_group_id                     = var.virtual_machine_scale_set.capacity_reservation_group_id
  custom_data                                       = var.virtual_machine_scale_set.custom_data
  do_not_run_extensions_on_overprovisioned_machines = var.virtual_machine_scale_set.do_not_run_extensions_on_overprovisioned_machines
  eviction_policy                                   = var.virtual_machine_scale_set.eviction_policy
  health_probe_id                                   = var.virtual_machine_scale_set.health_probe_id
  host_group_id                                     = var.virtual_machine_scale_set.host_group_id
  max_bid_price                                     = var.virtual_machine_scale_set.max_bid_price
  proximity_placement_group_id                      = var.virtual_machine_scale_set.proximity_placement_group_id
  single_placement_group                            = var.virtual_machine_scale_set.single_placement_group
  source_image_id                                   = var.virtual_machine_scale_set.source_image_id
  user_data                                         = var.virtual_machine_scale_set.user_data

  computer_name_prefix = coalesce(
    var.virtual_machine_scale_set.computer_name_prefix, var.virtual_machine_scale_set.name
  )

  tags = coalesce(
    var.virtual_machine_scale_set.tags, var.tags
  )

  disable_password_authentication = (
    var.virtual_machine_scale_set.admin_password != null ? false : var.virtual_machine_scale_set.public_key != null ? true : var.virtual_machine_scale_set.disable_password_authentication
  )

  dynamic "source_image_reference" {
    for_each = var.virtual_machine_scale_set.source_image_id == null ? { "this" = coalesce(
      var.virtual_machine_scale_set.source_image_reference, var.source_image_reference
    ) } : {}

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  os_disk {
    storage_account_type             = var.virtual_machine_scale_set.os_disk.storage_account_type
    caching                          = var.virtual_machine_scale_set.os_disk.caching
    disk_encryption_set_id           = var.virtual_machine_scale_set.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.virtual_machine_scale_set.os_disk.disk_size_gb
    secure_vm_disk_encryption_set_id = var.virtual_machine_scale_set.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.virtual_machine_scale_set.os_disk.security_encryption_type
    write_accelerator_enabled        = var.virtual_machine_scale_set.os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.virtual_machine_scale_set.diff_disk_settings != null ? { "this" = var.virtual_machine_scale_set.diff_disk_settings } : {}

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.virtual_machine_scale_set.additional_capabilities != null ? { "this" = var.virtual_machine_scale_set.additional_capabilities } : {}

    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.virtual_machine_scale_set.public_key != null ? { "this" = var.virtual_machine_scale_set.public_key } : {}

    content {
      username   = var.virtual_machine_scale_set.username
      public_key = var.virtual_machine_scale_set.public_key
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.virtual_machine_scale_set.automatic_instance_repair != null ? { "this" = var.virtual_machine_scale_set.automatic_instance_repair } : {}

    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.virtual_machine_scale_set.automatic_os_upgrade_policy != null ? { "this" = var.virtual_machine_scale_set.automatic_os_upgrade_policy } : {}

    content {
      automatic_rollback_enabled   = automatic_os_upgrade_policy.value.automatic_rollback_enabled
      automatic_os_upgrade_enabled = automatic_os_upgrade_policy.value.automatic_os_upgrade_enabled
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.virtual_machine_scale_set.boot_diagnostics != null ? { "this" = var.virtual_machine_scale_set.boot_diagnostics } : {}

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "data_disk" {
    for_each = var.virtual_machine_scale_set.disks

    content {
      name                      = data_disk.value.name
      caching                   = data_disk.value.caching
      create_option             = data_disk.value.create_option
      disk_size_gb              = data_disk.value.disk_size_gb
      lun                       = data_disk.value.lun
      storage_account_type      = data_disk.value.storage_account_type
      disk_encryption_set_id    = data_disk.value.disk_encryption_set_id
      disk_iops_read_write      = data_disk.value.disk_iops_read_write
      disk_mbps_read_write      = data_disk.value.disk_mbps_read_write
      write_accelerator_enabled = data_disk.value.write_accelerator_enabled
    }
  }

  dynamic "gallery_application" {
    for_each = var.virtual_machine_scale_set.gallery_applications

    content {
      tag                    = gallery_application.value.tag
      order                  = gallery_application.value.order
      version_id             = gallery_application.value.version_id
      configuration_blob_uri = gallery_application.value.configuration_blob_uri
    }
  }

  dynamic "identity" {
    for_each = var.virtual_machine_scale_set.identity != null ? { "this" = var.virtual_machine_scale_set.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_interface" {
    for_each = var.virtual_machine_scale_set.interfaces

    content {
      name                           = coalesce(network_interface.value.name, "nic-${network_interface.key}")
      primary                        = network_interface.value.primary
      dns_servers                    = network_interface.value.dns_servers
      accelerated_networking_enabled = network_interface.value.accelerated_networking_enabled
      ip_forwarding_enabled          = network_interface.value.ip_forwarding_enabled
      auxiliary_mode                 = network_interface.value.auxiliary_mode
      auxiliary_sku                  = network_interface.value.auxiliary_sku
      network_security_group_id      = network_interface.value.network_security_group_id

      ip_configuration {
        name                                         = coalesce(network_interface.value.ip_configuration.name, "ipconf-${network_interface.key}")
        primary                                      = network_interface.value.primary
        subnet_id                                    = network_interface.value.subnet
        application_gateway_backend_address_pool_ids = network_interface.value.application_gateway_backend_address_pool_ids
        application_security_group_ids               = network_interface.value.application_security_group_ids
        load_balancer_backend_address_pool_ids       = network_interface.value.load_balancer_backend_address_pool_ids
        load_balancer_inbound_nat_rules_ids          = network_interface.value.load_balancer_inbound_nat_rules_ids
        version                                      = network_interface.value.ip_configuration.version

        dynamic "public_ip_address" {
          for_each = network_interface.value.public_ip_address != null ? { "this" = network_interface.value.public_ip_address } : {}

          content {
            name                    = coalesce(public_ip_address.value.name, "pip-${network_interface.key}")
            idle_timeout_in_minutes = public_ip_address.value.idle_timeout_in_minutes
            domain_name_label       = public_ip_address.value.domain_name_label
            public_ip_prefix_id     = public_ip_address.value.public_ip_prefix_id
            version                 = public_ip_address.value.version

            dynamic "ip_tag" {
              for_each = public_ip_address.value.ip_tags

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
    for_each = var.virtual_machine_scale_set.plan != null ? { "this" = var.virtual_machine_scale_set.plan } : {}

    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.virtual_machine_scale_set.rolling_upgrade_policy != null ? { "this" = var.virtual_machine_scale_set.rolling_upgrade_policy } : {}

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
    for_each = var.virtual_machine_scale_set.scale_in != null ? { "this" = var.virtual_machine_scale_set.scale_in } : {}

    content {
      rule                   = scale_in.value.rule
      force_deletion_enabled = scale_in.value.force_deletion_enabled
    }
  }

  dynamic "secret" {
    for_each = var.virtual_machine_scale_set.secrets

    content {
      key_vault_id = secret.value.key_vault_id

      certificate {
        url = secret.value.certificate.url
      }
    }
  }

  dynamic "spot_restore" {
    for_each = var.virtual_machine_scale_set.spot_restore != null ? { "this" = var.virtual_machine_scale_set.spot_restore } : {}

    content {
      enabled = spot_restore.value.enabled
      timeout = spot_restore.value.timeout
    }
  }

  dynamic "termination_notification" {
    for_each = var.virtual_machine_scale_set.termination_notification != null ? { "this" = var.virtual_machine_scale_set.termination_notification } : {}

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  lifecycle {
    # instances is managed by autoscaling; extension is managed by azurerm_virtual_machine_scale_set_extension
    ignore_changes = [instances, extension]
  }
}

# scale set windows
resource "azurerm_windows_virtual_machine_scale_set" "this" {
  for_each = var.virtual_machine_scale_set.type == "windows" ? { "this" = true } : {}

  resource_group_name = coalesce(
    var.virtual_machine_scale_set.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.virtual_machine_scale_set.location, var.location
  )

  name                                              = var.virtual_machine_scale_set.name
  admin_password                                    = var.virtual_machine_scale_set.admin_password
  automatic_updates_enabled                         = var.virtual_machine_scale_set.automatic_updates_enabled
  license_type                                      = var.virtual_machine_scale_set.license_type
  timezone                                          = var.virtual_machine_scale_set.timezone
  sku                                               = var.virtual_machine_scale_set.sku
  instances                                         = var.virtual_machine_scale_set.instances
  admin_username                                    = var.virtual_machine_scale_set.admin_username
  upgrade_mode                                      = var.virtual_machine_scale_set.upgrade_mode
  provision_vm_agent                                = var.virtual_machine_scale_set.provision_vm_agent
  platform_fault_domain_count                       = var.virtual_machine_scale_set.platform_fault_domain_count
  priority                                          = var.virtual_machine_scale_set.priority
  resilient_vm_creation_enabled                     = var.virtual_machine_scale_set.resilient_vm_creation_enabled
  resilient_vm_deletion_enabled                     = var.virtual_machine_scale_set.resilient_vm_deletion_enabled
  secure_boot_enabled                               = var.virtual_machine_scale_set.secure_boot_enabled
  vtpm_enabled                                      = var.virtual_machine_scale_set.vtpm_enabled
  zone_balance                                      = var.virtual_machine_scale_set.zone_balance
  zones                                             = var.virtual_machine_scale_set.zones
  edge_zone                                         = var.virtual_machine_scale_set.edge_zone
  encryption_at_host_enabled                        = var.virtual_machine_scale_set.encryption_at_host_enabled
  extension_operations_enabled                      = var.virtual_machine_scale_set.extension_operations_enabled
  extensions_time_budget                            = var.virtual_machine_scale_set.extensions_time_budget
  overprovision                                     = var.virtual_machine_scale_set.overprovision
  capacity_reservation_group_id                     = var.virtual_machine_scale_set.capacity_reservation_group_id
  custom_data                                       = var.virtual_machine_scale_set.custom_data
  do_not_run_extensions_on_overprovisioned_machines = var.virtual_machine_scale_set.do_not_run_extensions_on_overprovisioned_machines
  eviction_policy                                   = var.virtual_machine_scale_set.eviction_policy
  health_probe_id                                   = var.virtual_machine_scale_set.health_probe_id
  host_group_id                                     = var.virtual_machine_scale_set.host_group_id
  max_bid_price                                     = var.virtual_machine_scale_set.max_bid_price
  proximity_placement_group_id                      = var.virtual_machine_scale_set.proximity_placement_group_id
  single_placement_group                            = var.virtual_machine_scale_set.single_placement_group
  source_image_id                                   = var.virtual_machine_scale_set.source_image_id
  user_data                                         = var.virtual_machine_scale_set.user_data

  computer_name_prefix = coalesce(
    var.virtual_machine_scale_set.computer_name_prefix, var.virtual_machine_scale_set.name
  )

  tags = coalesce(
    var.virtual_machine_scale_set.tags, var.tags
  )

  dynamic "source_image_reference" {
    for_each = var.virtual_machine_scale_set.source_image_id == null ? { "this" = coalesce(
      var.virtual_machine_scale_set.source_image_reference, var.source_image_reference
    ) } : {}

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  os_disk {
    storage_account_type             = var.virtual_machine_scale_set.os_disk.storage_account_type
    caching                          = var.virtual_machine_scale_set.os_disk.caching
    disk_encryption_set_id           = var.virtual_machine_scale_set.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.virtual_machine_scale_set.os_disk.disk_size_gb
    secure_vm_disk_encryption_set_id = var.virtual_machine_scale_set.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.virtual_machine_scale_set.os_disk.security_encryption_type
    write_accelerator_enabled        = var.virtual_machine_scale_set.os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.virtual_machine_scale_set.diff_disk_settings != null ? { "this" = var.virtual_machine_scale_set.diff_disk_settings } : {}

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.virtual_machine_scale_set.additional_capabilities != null ? { "this" = var.virtual_machine_scale_set.additional_capabilities } : {}

    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  dynamic "additional_unattend_content" {
    for_each = var.virtual_machine_scale_set.additional_unattend_content != null ? { "this" = var.virtual_machine_scale_set.additional_unattend_content } : {}

    content {
      content = additional_unattend_content.value.content
      setting = additional_unattend_content.value.setting
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.virtual_machine_scale_set.automatic_os_upgrade_policy != null ? { "this" = var.virtual_machine_scale_set.automatic_os_upgrade_policy } : {}

    content {
      automatic_rollback_enabled   = automatic_os_upgrade_policy.value.automatic_rollback_enabled
      automatic_os_upgrade_enabled = automatic_os_upgrade_policy.value.automatic_os_upgrade_enabled
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.virtual_machine_scale_set.automatic_instance_repair != null ? { "this" = var.virtual_machine_scale_set.automatic_instance_repair } : {}

    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.virtual_machine_scale_set.boot_diagnostics != null ? { "this" = var.virtual_machine_scale_set.boot_diagnostics } : {}

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "data_disk" {
    for_each = var.virtual_machine_scale_set.disks

    content {
      name                      = data_disk.value.name
      caching                   = data_disk.value.caching
      create_option             = data_disk.value.create_option
      disk_size_gb              = data_disk.value.disk_size_gb
      lun                       = data_disk.value.lun
      storage_account_type      = data_disk.value.storage_account_type
      disk_encryption_set_id    = data_disk.value.disk_encryption_set_id
      disk_iops_read_write      = data_disk.value.disk_iops_read_write
      disk_mbps_read_write      = data_disk.value.disk_mbps_read_write
      write_accelerator_enabled = data_disk.value.write_accelerator_enabled
    }
  }

  dynamic "gallery_application" {
    for_each = var.virtual_machine_scale_set.gallery_applications

    content {
      tag                    = gallery_application.value.tag
      order                  = gallery_application.value.order
      version_id             = gallery_application.value.version_id
      configuration_blob_uri = gallery_application.value.configuration_blob_uri
    }
  }

  dynamic "identity" {
    for_each = var.virtual_machine_scale_set.identity != null ? { "this" = var.virtual_machine_scale_set.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_interface" {
    for_each = var.virtual_machine_scale_set.interfaces

    content {
      name                           = coalesce(network_interface.value.name, "nic-${network_interface.key}")
      primary                        = network_interface.value.primary
      dns_servers                    = network_interface.value.dns_servers
      accelerated_networking_enabled = network_interface.value.accelerated_networking_enabled
      ip_forwarding_enabled          = network_interface.value.ip_forwarding_enabled
      auxiliary_mode                 = network_interface.value.auxiliary_mode
      auxiliary_sku                  = network_interface.value.auxiliary_sku
      network_security_group_id      = network_interface.value.network_security_group_id

      ip_configuration {
        name                                         = coalesce(network_interface.value.ip_configuration.name, "ipconf-${network_interface.key}")
        primary                                      = network_interface.value.primary
        subnet_id                                    = network_interface.value.subnet
        application_gateway_backend_address_pool_ids = network_interface.value.application_gateway_backend_address_pool_ids
        application_security_group_ids               = network_interface.value.application_security_group_ids
        load_balancer_backend_address_pool_ids       = network_interface.value.load_balancer_backend_address_pool_ids
        load_balancer_inbound_nat_rules_ids          = network_interface.value.load_balancer_inbound_nat_rules_ids
        version                                      = network_interface.value.ip_configuration.version

        dynamic "public_ip_address" {
          for_each = network_interface.value.public_ip_address != null ? { "this" = network_interface.value.public_ip_address } : {}

          content {
            name                    = coalesce(public_ip_address.value.name, "pip-${network_interface.key}")
            idle_timeout_in_minutes = public_ip_address.value.idle_timeout_in_minutes
            domain_name_label       = public_ip_address.value.domain_name_label
            public_ip_prefix_id     = public_ip_address.value.public_ip_prefix_id
            version                 = public_ip_address.value.version

            dynamic "ip_tag" {
              for_each = public_ip_address.value.ip_tags

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
    for_each = var.virtual_machine_scale_set.plan != null ? { "this" = var.virtual_machine_scale_set.plan } : {}

    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.virtual_machine_scale_set.rolling_upgrade_policy != null ? { "this" = var.virtual_machine_scale_set.rolling_upgrade_policy } : {}

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
    for_each = var.virtual_machine_scale_set.secrets

    content {
      key_vault_id = secret.value.key_vault_id

      certificate {
        url   = secret.value.certificate.url
        store = secret.value.certificate.store
      }
    }
  }

  dynamic "scale_in" {
    for_each = var.virtual_machine_scale_set.scale_in != null ? { "this" = var.virtual_machine_scale_set.scale_in } : {}

    content {
      rule                   = scale_in.value.rule
      force_deletion_enabled = scale_in.value.force_deletion_enabled
    }
  }

  dynamic "spot_restore" {
    for_each = var.virtual_machine_scale_set.spot_restore != null ? { "this" = var.virtual_machine_scale_set.spot_restore } : {}

    content {
      enabled = spot_restore.value.enabled
      timeout = spot_restore.value.timeout
    }
  }

  dynamic "termination_notification" {
    for_each = var.virtual_machine_scale_set.termination_notification != null ? { "this" = var.virtual_machine_scale_set.termination_notification } : {}

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  dynamic "winrm_listener" {
    for_each = var.virtual_machine_scale_set.winrm_listener != null ? { "this" = var.virtual_machine_scale_set.winrm_listener } : {}

    content {
      certificate_url = winrm_listener.value.certificate_url
      protocol        = winrm_listener.value.protocol
    }
  }

  lifecycle {
    # instances is managed by autoscaling; extension is managed by azurerm_virtual_machine_scale_set_extension
    ignore_changes = [instances, extension]
  }
}

# scale set flex (orchestrated)
resource "azurerm_orchestrated_virtual_machine_scale_set" "this" {
  for_each = var.virtual_machine_scale_set.type == "flex" ? { "this" = true } : {}

  resource_group_name = coalesce(
    var.virtual_machine_scale_set.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.virtual_machine_scale_set.location, var.location
  )

  name                          = var.virtual_machine_scale_set.name
  network_api_version           = var.virtual_machine_scale_set.network_api_version
  platform_fault_domain_count   = var.virtual_machine_scale_set.platform_fault_domain_count
  proximity_placement_group_id  = var.virtual_machine_scale_set.proximity_placement_group_id
  single_placement_group        = var.virtual_machine_scale_set.single_placement_group
  zone_balance                  = var.virtual_machine_scale_set.zone_balance
  zones                         = var.virtual_machine_scale_set.zones
  upgrade_mode                  = var.virtual_machine_scale_set.upgrade_mode
  encryption_at_host_enabled    = var.virtual_machine_scale_set.encryption_at_host_enabled
  extension_operations_enabled  = var.virtual_machine_scale_set.extension_operations_enabled
  extensions_time_budget        = var.virtual_machine_scale_set.extensions_time_budget
  capacity_reservation_group_id = var.virtual_machine_scale_set.capacity_reservation_group_id
  source_image_id               = var.virtual_machine_scale_set.source_image_id
  user_data_base64              = var.virtual_machine_scale_set.user_data != null ? base64encode(var.virtual_machine_scale_set.user_data) : null
  instances                     = var.virtual_machine_scale_set.instances
  sku_name                      = var.virtual_machine_scale_set.sku
  eviction_policy               = var.virtual_machine_scale_set.eviction_policy
  max_bid_price                 = var.virtual_machine_scale_set.max_bid_price
  priority                      = var.virtual_machine_scale_set.priority
  license_type                  = var.virtual_machine_scale_set.license_type

  tags = coalesce(
    var.virtual_machine_scale_set.tags, var.tags
  )

  dynamic "additional_capabilities" {
    for_each = var.virtual_machine_scale_set.additional_capabilities != null ? { "this" = var.virtual_machine_scale_set.additional_capabilities } : {}

    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.virtual_machine_scale_set.automatic_instance_repair != null ? { "this" = var.virtual_machine_scale_set.automatic_instance_repair } : {}

    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.virtual_machine_scale_set.boot_diagnostics != null ? { "this" = var.virtual_machine_scale_set.boot_diagnostics } : {}

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "identity" {
    for_each = var.virtual_machine_scale_set.identity != null ? { "this" = var.virtual_machine_scale_set.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_interface" {
    for_each = var.virtual_machine_scale_set.interfaces

    content {
      name                           = coalesce(network_interface.value.name, "nic-${network_interface.key}")
      primary                        = network_interface.value.primary
      dns_servers                    = network_interface.value.dns_servers
      accelerated_networking_enabled = network_interface.value.accelerated_networking_enabled
      ip_forwarding_enabled          = network_interface.value.ip_forwarding_enabled
      auxiliary_mode                 = network_interface.value.auxiliary_mode
      auxiliary_sku                  = network_interface.value.auxiliary_sku
      network_security_group_id      = network_interface.value.network_security_group_id

      ip_configuration {
        name                                         = coalesce(network_interface.value.ip_configuration.name, "ipconf-${network_interface.key}")
        primary                                      = network_interface.value.primary
        subnet_id                                    = network_interface.value.subnet
        application_gateway_backend_address_pool_ids = network_interface.value.application_gateway_backend_address_pool_ids
        application_security_group_ids               = network_interface.value.application_security_group_ids
        load_balancer_backend_address_pool_ids       = network_interface.value.load_balancer_backend_address_pool_ids
        version                                      = network_interface.value.ip_configuration.version

        dynamic "public_ip_address" {
          for_each = network_interface.value.public_ip_address != null ? { "this" = network_interface.value.public_ip_address } : {}

          content {
            name                    = coalesce(public_ip_address.value.name, "pip-${network_interface.key}")
            domain_name_label       = public_ip_address.value.domain_name_label
            idle_timeout_in_minutes = public_ip_address.value.idle_timeout_in_minutes
            public_ip_prefix_id     = public_ip_address.value.public_ip_prefix_id
            sku_name                = public_ip_address.value.sku_name
            version                 = public_ip_address.value.version

            dynamic "ip_tag" {
              for_each = public_ip_address.value.ip_tags

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

  os_disk {
    storage_account_type      = var.virtual_machine_scale_set.os_disk.storage_account_type
    caching                   = var.virtual_machine_scale_set.os_disk.caching
    disk_encryption_set_id    = var.virtual_machine_scale_set.os_disk.disk_encryption_set_id
    disk_size_gb              = var.virtual_machine_scale_set.os_disk.disk_size_gb
    write_accelerator_enabled = var.virtual_machine_scale_set.os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.virtual_machine_scale_set.diff_disk_settings != null ? { "this" = var.virtual_machine_scale_set.diff_disk_settings } : {}

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "os_profile" {
    for_each = anytrue([
      var.virtual_machine_scale_set.source_image_id != null,
      var.virtual_machine_scale_set.source_image_reference != null,
      var.source_image_reference != null,
    ]) ? { "this" = var.virtual_machine_scale_set } : {}

    content {
      custom_data = var.virtual_machine_scale_set.custom_data != null ? base64encode(var.virtual_machine_scale_set.custom_data) : null

      dynamic "linux_configuration" {
        for_each = lower(coalesce(var.virtual_machine_scale_set.os_type, "linux")) == "linux" ? { "this" = var.virtual_machine_scale_set } : {}

        content {
          disable_password_authentication = (
            var.virtual_machine_scale_set.admin_password != null ? false : var.virtual_machine_scale_set.public_key != null ? true : var.virtual_machine_scale_set.disable_password_authentication
          )
          admin_username     = var.virtual_machine_scale_set.admin_username
          admin_password     = var.virtual_machine_scale_set.admin_password
          provision_vm_agent = var.virtual_machine_scale_set.provision_vm_agent
          computer_name_prefix = coalesce(
            var.virtual_machine_scale_set.computer_name_prefix, var.virtual_machine_scale_set.name
          )
          patch_assessment_mode = var.virtual_machine_scale_set.patch_assessment_mode
          patch_mode            = var.virtual_machine_scale_set.patch_mode

          dynamic "admin_ssh_key" {
            for_each = var.virtual_machine_scale_set.public_key != null ? { "this" = var.virtual_machine_scale_set.public_key } : {}

            content {
              username   = var.virtual_machine_scale_set.username
              public_key = var.virtual_machine_scale_set.public_key
            }
          }

          dynamic "secret" {
            for_each = var.virtual_machine_scale_set.secrets

            content {
              key_vault_id = secret.value.key_vault_id

              dynamic "certificate" {
                for_each = { "this" = secret.value.certificate }

                content {
                  url = certificate.value.url
                }
              }
            }
          }
        }
      }

      dynamic "windows_configuration" {
        for_each = lower(coalesce(var.virtual_machine_scale_set.os_type, "linux")) == "windows" ? { "this" = var.virtual_machine_scale_set } : {}

        content {
          admin_username            = var.virtual_machine_scale_set.admin_username
          admin_password            = var.virtual_machine_scale_set.admin_password
          automatic_updates_enabled = var.virtual_machine_scale_set.automatic_updates_enabled
          provision_vm_agent        = var.virtual_machine_scale_set.provision_vm_agent
          timezone                  = var.virtual_machine_scale_set.timezone
          computer_name_prefix = coalesce(
            var.virtual_machine_scale_set.computer_name_prefix, var.virtual_machine_scale_set.name
          )
          patch_assessment_mode = var.virtual_machine_scale_set.patch_assessment_mode
          patch_mode            = var.virtual_machine_scale_set.patch_mode
          hotpatching_enabled   = var.virtual_machine_scale_set.hotpatching_enabled

          dynamic "additional_unattend_content" {
            for_each = var.virtual_machine_scale_set.additional_unattend_content != null ? { "this" = var.virtual_machine_scale_set.additional_unattend_content } : {}

            content {
              content = additional_unattend_content.value.content
              setting = additional_unattend_content.value.setting
            }
          }

          dynamic "secret" {
            for_each = var.virtual_machine_scale_set.secrets

            content {
              key_vault_id = secret.value.key_vault_id

              dynamic "certificate" {
                for_each = { "this" = secret.value.certificate }

                content {
                  url   = certificate.value.url
                  store = certificate.value.store
                }
              }
            }
          }

          dynamic "winrm_listener" {
            for_each = var.virtual_machine_scale_set.winrm_listener != null ? { "this" = var.virtual_machine_scale_set.winrm_listener } : {}

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
    for_each = var.virtual_machine_scale_set.disks

    content {
      caching                   = data_disk.value.caching
      create_option             = data_disk.value.create_option
      disk_encryption_set_id    = data_disk.value.disk_encryption_set_id
      disk_size_gb              = data_disk.value.disk_size_gb
      lun                       = data_disk.value.lun
      storage_account_type      = data_disk.value.storage_account_type
      disk_iops_read_write      = data_disk.value.disk_iops_read_write
      disk_mbps_read_write      = data_disk.value.disk_mbps_read_write
      write_accelerator_enabled = data_disk.value.write_accelerator_enabled
    }
  }

  dynamic "source_image_reference" {
    for_each = var.virtual_machine_scale_set.source_image_id == null ? { "this" = coalesce(
      var.virtual_machine_scale_set.source_image_reference, var.source_image_reference
    ) } : {}

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  dynamic "plan" {
    for_each = var.virtual_machine_scale_set.plan != null ? { "this" = var.virtual_machine_scale_set.plan } : {}

    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }

  dynamic "priority_mix" {
    for_each = var.virtual_machine_scale_set.priority == "Spot" && var.virtual_machine_scale_set.priority_mix != null ? { "this" = var.virtual_machine_scale_set.priority_mix } : {}

    content {
      base_regular_count            = priority_mix.value.base_regular_count
      regular_percentage_above_base = priority_mix.value.regular_percentage_above_base
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.virtual_machine_scale_set.rolling_upgrade_policy != null ? { "this" = var.virtual_machine_scale_set.rolling_upgrade_policy } : {}

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
    for_each = var.virtual_machine_scale_set.sku_profile != null ? { "this" = var.virtual_machine_scale_set.sku_profile } : {}

    content {
      allocation_strategy = sku_profile.value.allocation_strategy

      dynamic "virtual_machine_size" {
        for_each = sku_profile.value.virtual_machine_sizes

        content {
          name = virtual_machine_size.value.name
          rank = virtual_machine_size.value.rank
        }
      }
    }
  }

  dynamic "termination_notification" {
    for_each = var.virtual_machine_scale_set.termination_notification != null ? { "this" = var.virtual_machine_scale_set.termination_notification } : {}

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  dynamic "extension" {
    for_each = var.virtual_machine_scale_set.extensions

    content {
      name                                = coalesce(extension.value.name, extension.key)
      publisher                           = extension.value.publisher
      type                                = extension.value.type
      type_handler_version                = extension.value.type_handler_version
      settings                            = extension.value.settings
      protected_settings                  = extension.value.protected_settings
      failure_suppression_enabled         = extension.value.failure_suppression_enabled
      force_extension_execution_on_change = extension.value.force_extension_execution_on_change

      dynamic "protected_settings_from_key_vault" {
        for_each = extension.value.protected_settings_from_key_vault != null ? { "this" = extension.value.protected_settings_from_key_vault } : {}

        content {
          secret_url      = protected_settings_from_key_vault.value.secret_url
          source_vault_id = protected_settings_from_key_vault.value.source_vault_id
        }
      }
    }
  }

  lifecycle {
    # extension is managed inline on individual instances for flex scale sets
    ignore_changes = [extension]
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "this" {
  # For Flex VMSS, extensions are defined within the VMSS resource itself so they run on individual instances.
  for_each = var.virtual_machine_scale_set.type != "flex" ? var.virtual_machine_scale_set.extensions : {}

  name = coalesce(
    each.value.name, each.key
  )

  virtual_machine_scale_set_id = var.virtual_machine_scale_set.type == "linux" ? azurerm_linux_virtual_machine_scale_set.this["this"].id : azurerm_windows_virtual_machine_scale_set.this["this"].id
  publisher                    = each.value.publisher
  type                         = each.value.type
  type_handler_version         = each.value.type_handler_version
  auto_upgrade_minor_version   = each.value.auto_upgrade_minor_version
  settings                     = each.value.settings
  protected_settings           = each.value.protected_settings

  force_update_tag            = each.value.force_update_tag
  provision_after_extensions  = each.value.provision_after_extensions
  failure_suppression_enabled = each.value.failure_suppression_enabled
  automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled

  dynamic "protected_settings_from_key_vault" {
    for_each = each.value.protected_settings_from_key_vault != null ? { "this" = each.value.protected_settings_from_key_vault } : {}

    content {
      secret_url      = protected_settings_from_key_vault.value.secret_url
      source_vault_id = protected_settings_from_key_vault.value.source_vault_id
    }
  }
}

# autoscaling
resource "azurerm_monitor_autoscale_setting" "this" {
  for_each = var.virtual_machine_scale_set.autoscaling != null ? { "this" = var.virtual_machine_scale_set.autoscaling } : {}

  name = coalesce(
    var.virtual_machine_scale_set.autoscaling.name, "scaler"
  )

  resource_group_name = coalesce(var.virtual_machine_scale_set.resource_group_name, var.resource_group_name)
  location            = coalesce(var.virtual_machine_scale_set.location, var.location)

  target_resource_id = var.virtual_machine_scale_set.type == "linux" ? azurerm_linux_virtual_machine_scale_set.this["this"].id : var.virtual_machine_scale_set.type == "windows" ? azurerm_windows_virtual_machine_scale_set.this["this"].id : azurerm_orchestrated_virtual_machine_scale_set.this["this"].id
  enabled            = var.virtual_machine_scale_set.autoscaling.enabled

  tags = coalesce(
    var.virtual_machine_scale_set.tags, var.tags
  )

  dynamic "profile" {
    for_each = var.virtual_machine_scale_set.autoscaling.profiles

    content {
      name = profile.value.name

      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "fixed_date" {
        for_each = profile.value.fixed_date != null ? { "this" = profile.value.fixed_date } : {}

        content {
          end      = fixed_date.value.end
          start    = fixed_date.value.start
          timezone = fixed_date.value.timezone
        }
      }

      dynamic "recurrence" {
        for_each = profile.value.recurrence != null ? { "this" = profile.value.recurrence } : {}

        content {
          timezone = recurrence.value.timezone
          days     = recurrence.value.days
          hours    = recurrence.value.hours
          minutes  = recurrence.value.minutes
        }
      }

      dynamic "rule" {
        for_each = profile.value.rules

        content {
          metric_trigger {
            metric_name              = rule.value.metric_trigger.metric_name
            metric_resource_id       = coalesce(rule.value.metric_trigger.metric_resource_id, var.virtual_machine_scale_set.type == "linux" ? azurerm_linux_virtual_machine_scale_set.this["this"].id : var.virtual_machine_scale_set.type == "windows" ? azurerm_windows_virtual_machine_scale_set.this["this"].id : azurerm_orchestrated_virtual_machine_scale_set.this["this"].id)
            metric_namespace         = rule.value.metric_trigger.metric_namespace
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            time_window              = rule.value.metric_trigger.time_window
            time_grain               = rule.value.metric_trigger.time_grain
            statistic                = rule.value.metric_trigger.statistic
            operator                 = rule.value.metric_trigger.operator
            threshold                = rule.value.metric_trigger.threshold
            divide_by_instance_count = rule.value.metric_trigger.divide_by_instance_count

            dynamic "dimensions" {
              for_each = coalesce(rule.value.metric_trigger.dimensions, [])

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
    for_each = var.virtual_machine_scale_set.autoscaling.notification != null ? { "this" = var.virtual_machine_scale_set.autoscaling.notification } : {}

    content {
      dynamic "email" {
        for_each = notification.value.email != null ? { "this" = notification.value.email } : {}

        content {
          custom_emails                         = email.value.custom_emails
          send_to_subscription_administrator    = email.value.send_to_subscription_administrator
          send_to_subscription_co_administrator = email.value.send_to_subscription_co_administrator
        }
      }

      dynamic "webhook" {
        for_each = coalesce(notification.value.webhook, [])

        content {
          service_uri = webhook.value.service_uri
          properties  = webhook.value.properties
        }
      }
    }
  }

  dynamic "predictive" {
    for_each = var.virtual_machine_scale_set.autoscaling.predictive != null ? { "this" = var.virtual_machine_scale_set.autoscaling.predictive } : {}

    content {
      scale_mode      = predictive.value.scale_mode
      look_ahead_time = predictive.value.look_ahead_time
    }
  }
}
