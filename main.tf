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
  admin_password                                    = var.vmss.disable_password_authentication == false && var.vmss.admin_password != null ? var.vmss.admin_password : var.vmss.disable_password_authentication == false ? try(azurerm_key_vault_secret.secret[var.vmss.name].value, null) : null
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

  computer_name_prefix = coalesce(
    var.vmss.computer_name_prefix, var.vmss.name
  )

  tags = coalesce(
    var.vmss.tags, var.tags
  )

  disable_password_authentication = (
    var.vmss.admin_password != null ? false : var.vmss.public_key != null ||
    contains(keys(tls_private_key.tls_key), var.vmss.name) ? true : var.vmss.disable_password_authentication
  )

  dynamic "source_image_reference" {
    for_each = var.vmss.source_image_id == null ? [true] : []

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
      for_each = var.vmss.diff_disk_settings != null ? [var.vmss.diff_disk_settings] : []

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.vmss.additional_capabilities != null ? [var.vmss.additional_capabilities] : []

    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.vmss.public_key != null || contains(keys(tls_private_key.tls_key), var.vmss.name) ? [1] : []

    content {
      username   = var.vmss.username
      public_key = var.vmss.public_key != null ? var.vmss.public_key : tls_private_key.tls_key[var.vmss.name].public_key_openssh
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.vmss.automatic_instance_repair != null ? [var.vmss.automatic_instance_repair] : []

    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.vmss.automatic_os_upgrade_policy != null ? [var.vmss.automatic_os_upgrade_policy] : []

    content {
      disable_automatic_rollback  = automatic_os_upgrade_policy.value.disable_automatic_rollback
      enable_automatic_os_upgrade = automatic_os_upgrade_policy.value.enable_automatic_os_upgrade
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.vmss, "boot_diagnostics", null) != null ? [var.vmss.boot_diagnostics] : []

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "data_disk" {
    for_each = var.vmss.disks

    content {
      name = try(
        data_disk.value.name, join("-", [var.naming.managed_disk, data_disk.key])
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
    for_each = var.vmss.interfaces

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
    for_each = var.vmss.plan != null ? [var.vmss.plan] : []

    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.vmss.rolling_upgrade_policy != null ? [var.vmss.rolling_upgrade_policy] : []

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
    for_each = var.vmss.scale_in != null ? [var.vmss.scale_in] : []

    content {
      rule                   = scale_in.value.rule
      force_deletion_enabled = scale_in.value.force_deletion_enabled
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
    for_each = var.vmss.spot_restore != null ? [var.vmss.spot_restore] : []

    content {
      enabled = spot_restore.value.enabled
      timeout = spot_restore.value.timeout
    }
  }

  dynamic "termination_notification" {
    for_each = var.vmss.termination_notification != null ? [var.vmss.termination_notification] : []

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  lifecycle {
    ignore_changes = [instances, extension]
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

  name = format(
    "%s-%s-%s", "kvs", var.vmss.name, "pub"
  )

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

  name = format(
    "%s-%s-%s", "kvs", var.vmss.name, "priv"
  )

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
  for_each = try(var.vmss.generate_password.enable, false) ? { (var.vmss.name) = true } : {}

  length           = var.vmss.generate_password.length
  special          = var.vmss.generate_password.special
  min_lower        = var.vmss.generate_password.min_lower
  min_upper        = var.vmss.generate_password.min_upper
  min_special      = var.vmss.generate_password.min_special
  min_numeric      = var.vmss.generate_password.min_numeric
  lower            = var.vmss.generate_password.lower
  upper            = var.vmss.generate_password.upper
  numeric          = var.vmss.generate_password.numeric
  override_special = var.vmss.generate_password.override_special
  keepers          = var.vmss.generate_password.keepers
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = try(var.vmss.generate_password.enable, false) ? { (var.vmss.name) = true } : {}

  name = format(
    "%s-%s", "kvs", var.vmss.name
  )

  value            = random_password.password[var.vmss.name].result
  key_vault_id     = var.keyvault
  expiration_date  = var.vmss.generate_password.expiration_date
  not_before_date  = var.vmss.generate_password.not_before_date
  value_wo_version = var.vmss.generate_password.value_wo_version
  value_wo         = var.vmss.generate_password.value_wo
  content_type     = var.vmss.generate_password.content_type

  tags = coalesce(
    var.vmss.tags, var.tags
  )
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

  admin_password                                    = var.vmss.admin_password != null ? var.vmss.admin_password : try(azurerm_key_vault_secret.secret[var.vmss.name].value, null)
  enable_automatic_updates                          = var.vmss.enable_automatic_updates
  license_type                                      = var.vmss.license_type
  timezone                                          = var.vmss.timezone
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

  computer_name_prefix = coalesce(
    var.vmss.computer_name_prefix, var.vmss.name
  )

  tags = coalesce(
    var.vmss.tags, var.tags
  )

  dynamic "source_image_reference" {
    for_each = var.vmss.source_image_id == null ? [true] : []

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
      for_each = var.vmss.diff_disk_settings != null ? [var.vmss.diff_disk_settings] : []

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.vmss.additional_capabilities != null ? [var.vmss.additional_capabilities] : []

    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  dynamic "additional_unattend_content" {
    for_each = var.vmss.additional_unattend_content != null ? [var.vmss.additional_unattend_content] : []

    content {
      content = additional_unattend_content.value.content
      setting = additional_unattend_content.value.setting
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.vmss.automatic_os_upgrade_policy != null ? [var.vmss.automatic_os_upgrade_policy] : []

    content {
      disable_automatic_rollback  = automatic_os_upgrade_policy.value.disable_automatic_rollback
      enable_automatic_os_upgrade = automatic_os_upgrade_policy.value.enable_automatic_os_upgrade
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.vmss.automatic_instance_repair != null ? [var.vmss.automatic_instance_repair] : []

    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.vmss, "boot_diagnostics", null) != null ? [var.vmss.boot_diagnostics] : []

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "data_disk" {
    for_each = var.vmss.disks

    content {
      name = try(
        data_disk.value.name, join("-", [var.naming.managed_disk, data_disk.key])
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
    for_each = var.vmss.interfaces

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
    for_each = var.vmss.plan != null ? [1] : []

    content {
      name      = var.vmss.plan.name
      product   = var.vmss.plan.product
      publisher = var.vmss.plan.publisher
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.vmss.rolling_upgrade_policy != null ? [var.vmss.rolling_upgrade_policy] : []

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
    for_each = var.vmss.scale_in != null ? [var.vmss.scale_in] : []

    content {
      rule                   = scale_in.value.rule
      force_deletion_enabled = scale_in.value.force_deletion_enabled
    }
  }

  dynamic "spot_restore" {
    for_each = var.vmss.spot_restore != null ? [var.vmss.spot_restore] : []

    content {
      enabled = spot_restore.value.enabled
      timeout = spot_restore.value.timeout
    }
  }

  dynamic "termination_notification" {
    for_each = var.vmss.termination_notification != null ? [var.vmss.termination_notification] : []

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  dynamic "winrm_listener" {
    for_each = var.vmss.winrm_listener != null ? [var.vmss.winrm_listener] : []

    content {
      certificate_url = winrm_listener.value.certificate_url
      protocol        = winrm_listener.value.protocol
    }
  }

  lifecycle {
    ignore_changes = [instances, extension]
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
resource "azurerm_monitor_autoscale_setting" "scaling" {
  for_each = var.vmss.autoscaling != null ? { (var.vmss.name) = var.vmss.autoscaling } : {}

  name = coalesce(
    var.vmss.autoscaling.name, "scaler"
  )

  resource_group_name = coalesce(
    var.vmss.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.vmss.location, var.location
  )

  target_resource_id = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.name].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.name].id
  enabled            = var.vmss.autoscaling.enabled

  tags = coalesce(
    var.vmss.tags, var.tags
  )

  profile {
    name = coalesce(
      var.vmss.autoscaling.profile_name, "default"
    )

    capacity {
      default = var.vmss.autoscaling.default
      minimum = var.vmss.autoscaling.min
      maximum = var.vmss.autoscaling.max
    }

    dynamic "rule" {
      for_each = var.vmss.autoscaling.rules

      content {
        metric_trigger {
          metric_name              = rule.value.metric_name
          metric_resource_id       = var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.name].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.name].id
          metric_namespace         = rule.value.metric_namespace
          time_aggregation         = rule.value.time_aggregation
          time_window              = rule.value.time_window
          time_grain               = rule.value.time_grain
          statistic                = rule.value.statistic
          operator                 = rule.value.operator
          threshold                = rule.value.threshold
          divide_by_instance_count = rule.value.divide_by_instance_count

          dynamic "dimensions" {
            for_each = coalesce(
              rule.value.dimensions, []
            )

            content {
              name     = dimensions.value.name
              operator = dimensions.value.operator
              values   = dimensions.value.values
            }
          }
        }

        scale_action {
          direction = rule.value.direction
          type      = rule.value.type
          value     = rule.value.value
          cooldown  = rule.value.cooldown
        }
      }
    }

    dynamic "fixed_date" {
      for_each = var.vmss.autoscaling.fixed_date != null ? [var.vmss.autoscaling.fixed_date] : []

      content {
        end      = fixed_date.value.end
        start    = fixed_date.value.start
        timezone = fixed_date.value.timezone
      }
    }

    dynamic "recurrence" {
      for_each = var.vmss.autoscaling.recurrence != null ? [var.vmss.autoscaling.recurrence] : []

      content {
        timezone = recurrence.value.timezone
        days     = recurrence.value.days
        hours    = recurrence.value.hours
        minutes  = recurrence.value.minutes
      }
    }
  }

  dynamic "profile" {
    for_each = coalesce(
      var.vmss.autoscaling.profiles, []
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
        for_each = try(
          profile.value.rules, []
        )

        content {
          metric_trigger {
            metric_name              = rule.value.metric_trigger.metric_name
            metric_resource_id       = try(rule.value.metric_trigger.metric_resource_id, var.vmss.type == "linux" ? azurerm_linux_virtual_machine_scale_set.vmss[var.vmss.name].id : azurerm_windows_virtual_machine_scale_set.vmss[var.vmss.name].id)
            metric_namespace         = rule.value.metric_trigger.metric_namespace
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            time_window              = rule.value.metric_trigger.time_window
            time_grain               = rule.value.metric_trigger.time_grain
            statistic                = rule.value.metric_trigger.statistic
            operator                 = rule.value.metric_trigger.operator
            threshold                = rule.value.metric_trigger.threshold
            divide_by_instance_count = rule.value.metric_trigger.divide_by_instance_count

            dynamic "dimensions" {
              for_each = try(
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
    for_each = var.vmss.autoscaling.notification != null ? [var.vmss.autoscaling.notification] : []

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
    for_each = var.vmss.autoscaling.predictive != null ? [var.vmss.autoscaling.predictive] : []

    content {
      scale_mode      = predictive.value.scale_mode
      look_ahead_time = predictive.value.look_ahead_time
    }
  }
}
