variable "vmss" {
  description = "Contains all virtual machine scale set configuration"
  type = object({
    name                                              = string
    type                                              = string
    resource_group_name                               = optional(string, null)
    location                                          = optional(string, null)
    sku                                               = optional(string, "Standard_DS1_v2")
    instances                                         = optional(number, 2)
    username                                          = optional(string, "adminuser")
    admin_username                                    = optional(string, "adminuser")
    admin_password                                    = optional(string, null)
    password                                          = optional(string, null)
    computer_name_prefix                              = optional(string, null)
    custom_data                                       = optional(string, null)
    user_data                                         = optional(string, null)
    disable_password_authentication                   = optional(bool, true)
    upgrade_mode                                      = optional(string, "Automatic")
    provision_vm_agent                                = optional(bool, true)
    platform_fault_domain_count                       = optional(number, 5)
    priority                                          = optional(string, "Regular")
    secure_boot_enabled                               = optional(bool, false)
    vtpm_enabled                                      = optional(bool, false)
    zone_balance                                      = optional(bool, false)
    zones                                             = optional(list(string), ["2"])
    edge_zone                                         = optional(string, null)
    encryption_at_host_enabled                        = optional(bool, false)
    extension_operations_enabled                      = optional(bool, true)
    extensions_time_budget                            = optional(string, "PT1H30M")
    overprovision                                     = optional(bool, true)
    capacity_reservation_group_id                     = optional(string, null)
    do_not_run_extensions_on_overprovisioned_machines = optional(bool, false)
    eviction_policy                                   = optional(string, null)
    health_probe_id                                   = optional(string, null)
    host_group_id                                     = optional(string, null)
    max_bid_price                                     = optional(number, null)
    proximity_placement_group_id                      = optional(string, null)
    single_placement_group                            = optional(bool, true)
    source_image_id                                   = optional(string, null)
    ultra_ssd_enabled                                 = optional(bool, false)
    tags                                              = optional(map(string))
    public_key                                        = optional(string, null)
    # Windows-specific settings
    enable_automatic_updates = optional(bool, true)
    hotpatching_enabled      = optional(bool, false)
    timezone                 = optional(string, null)
    patch_mode               = optional(string, null)
    # Image configuration
    source_image_reference = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string, "latest")
    }), null)
    # OS Disk configuration
    os_disk = optional(object({
      storage_account_type             = optional(string, "Standard_LRS")
      caching                          = optional(string, "ReadWrite")
      disk_size_gb                     = optional(number, null)
      disk_encryption_set_id           = optional(string, null)
      security_encryption_type         = optional(string, null)
      write_accelerator_enabled        = optional(bool, false)
      secure_vm_disk_encryption_set_id = optional(string, null)
    }), {})
    # Diff disk settings
    diff_disk_settings = optional(object({
      option    = optional(string, null)
      placement = optional(string, null)
    }), null)
    # Network interfaces
    interfaces = map(object({
      subnet                                       = string
      primary                                      = optional(bool, false)
      dns_servers                                  = optional(list(string), [])
      enable_accelerated_networking                = optional(bool, false)
      enable_ip_forwarding                         = optional(bool, false)
      application_gateway_backend_address_pool_ids = optional(list(string), [])
      application_security_group_ids               = optional(list(string), [])
      load_balancer_backend_address_pool_ids       = optional(list(string), [])
      load_balancer_inbound_nat_rules_ids          = optional(list(string), [])
    }))
    # Data disks
    disks = optional(map(object({
      name                           = optional(string, null)
      caching                        = optional(string, "ReadWrite")
      create_option                  = optional(string, "Empty")
      disk_size_gb                   = optional(number, 10)
      lun                            = number
      storage_account_type           = optional(string, "Standard_LRS")
      disk_encryption_set_id         = optional(string, null)
      ultra_ssd_disk_iops_read_write = optional(number, null)
      ultra_ssd_disk_mbps_read_write = optional(number, null)
      write_accelerator_enabled      = optional(bool, false)
    })), {})
    # Extensions
    extensions = optional(map(object({
      name                        = optional(string, null)
      publisher                   = string
      type                        = string
      type_handler_version        = string
      settings                    = optional(map(any), {})
      protected_settings          = optional(map(string), {})
      auto_upgrade_minor_version  = optional(bool, true)
      automatic_upgrade_enabled   = optional(bool, false)
      failure_suppression_enabled = optional(bool, false)
      provision_after_extensions  = optional(list(string), [])
      force_update_tag            = optional(string, null)
    })), {})
    # Boot diagnostics
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string, null)
    }), null)
    # Automatic instance repair
    automatic_instance_repair = optional(object({
      enabled      = optional(bool, true)
      grace_period = optional(string, "PT30M")
    }), null)
    # Automatic OS upgrade policy
    automatic_os_upgrade_policy = optional(object({
      disable_automatic_rollback  = optional(bool, null)
      enable_automatic_os_upgrade = optional(bool, null)
    }), null)
    # Gallery application
    gallery_application = optional(object({
      version_id             = optional(string, null)
      configuration_blob_uri = optional(string, null)
      order                  = optional(number, null)
      tag                    = optional(string, null)
    }), null)
    # Identity
    identity = optional(object({
      type         = optional(string, "SystemAssigned")
      identity_ids = optional(list(string), [])
      name         = optional(string, null)
    }), null)
    # Plan
    plan = optional(object({
      name      = string
      publisher = string
      product   = string
    }), null)
    # Rolling upgrade policy
    rolling_upgrade_policy = optional(object({
      cross_zone_upgrades_enabled             = optional(bool, null)
      max_batch_instance_percent              = optional(number, null)
      max_unhealthy_instance_percent          = optional(number, null)
      max_unhealthy_upgraded_instance_percent = optional(number, null)
      pause_time_between_batches              = optional(string, null)
      prioritize_unhealthy_instances_enabled  = optional(bool, null)
    }), null)
    # Scale in policy
    scale_in = optional(object({
      rule                   = optional(string, null)
      force_deletion_enabled = optional(bool, null)
    }), null)
    # Secret
    secret = optional(object({
      key_vault_id = string
      certificate = optional(object({
        store = optional(string, null)
        url   = string
      }), null)
    }), null)
    # Spot restore
    spot_restore = optional(object({
      enabled = optional(bool, true)
      timeout = optional(string, "PT1H")
    }), null)
    # Termination notification
    termination_notification = optional(object({
      enabled = optional(bool, true)
      timeout = optional(string, "PT5M")
    }), null)
    # WinRM listener (Windows only)
    winrm_listener = optional(object({
      certificate_url = optional(string, null)
      protocol        = optional(string, null)
    }), null)
    # Additional unattend content (Windows only)
    additional_unattend_content = optional(object({
      content = optional(string, null)
      setting = optional(string, null)
    }), null)
    # SSH key generation settings (Linux only)
    generate_ssh_key = optional(object({
      enable           = optional(bool, false)
      algorithm        = optional(string, "RSA")
      rsa_bits         = optional(number, 4096)
      ecdsa_curve      = optional(string, null)
      expiration_date  = optional(string, null)
      not_before_date  = optional(string, null)
      value_wo_version = optional(number, null)
      value_wo         = optional(string, null)
      content_type     = optional(string, null)
    }), { enable = false })
    # Password generation settings (Windows only)
    generate_password = optional(object({
      enable           = optional(bool, false)
      length           = optional(number, 24)
      special          = optional(bool, true)
      min_lower        = optional(number, 5)
      min_upper        = optional(number, 7)
      min_special      = optional(number, 4)
      min_numeric      = optional(number, 5)
      numeric          = optional(bool, null)
      upper            = optional(bool, null)
      lower            = optional(bool, null)
      override_special = optional(string, null)
      expiration_date  = optional(string, null)
      not_before_date  = optional(string, null)
      value_wo_version = optional(number, null)
      value_wo         = optional(string, null)
      content_type     = optional(string, null)
      keepers          = optional(map(string), null)
    }), { enable = false })
    # Autoscaling configuration
    autoscaling = optional(object({
      min     = number
      max     = number
      default = optional(number, 1)
      rules = map(object({
        metric_name      = string
        time_aggregation = string
        time_window      = string
        operator         = string
        threshold        = number
        time_grain       = string
        direction        = string
        type             = string
        value            = string
        cooldown         = string
        statistic        = string
      }))
    }), null)
  })

  validation {
    condition     = contains(["windows", "linux"], var.vmss.type)
    error_message = "The vmss type must be either 'windows' or 'linux'."
  }

  validation {
    condition     = var.vmss.location != null || var.location != null
    error_message = "Location must be provided either in the vmss object or as a separate variable."
  }

  validation {
    condition     = var.vmss.resource_group_name != null || var.resource_group_name != null
    error_message = "Resource group name must be provided either in the vmss object or as a separate variable."
  }

  validation {
    condition = (
      var.vmss.type == "linux" ? (
        var.vmss.public_key != null || var.vmss.password != null || try(var.vmss.generate_ssh_key.enable, false) == true
        ) : (
        var.vmss.password != null || try(var.vmss.generate_password.enable, false) == true
      )
    )
    error_message = "For Linux VMSS, either 'public_key', 'password', or 'generate_ssh_key.enable' must be provided. For Windows VMSS, either 'password' or 'generate_password.enable' must be provided."
  }

  validation {
    condition = (
      var.vmss.type == "windows" || try(var.vmss.secret.certificate.store, null) == null
    )
    error_message = "Certificate store is only applicable when vmss type is 'windows'. Remove the store property for Linux instances."
  }
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
  default     = {}
}

variable "keyvault" {
  description = "keyvault id to store secrets"
  type        = string
  default     = null
}

variable "location" {
  description = "default azure region and can be used if location is not specified inside the object."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}

variable "source_image_reference" {
  description = "Default source image reference configuration to use when not specified at the vmss level"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}
