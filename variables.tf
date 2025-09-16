variable "vmss" {
  description = "Contains all virtual machine scale set configuration"
  type = object({
    name                                              = string
    type                                              = string
    resource_group_name                               = optional(string)
    location                                          = optional(string)
    sku                                               = optional(string, "Standard_DS1_v2")
    instances                                         = optional(number, 2)
    username                                          = optional(string, "adminuser")
    admin_username                                    = optional(string, "adminuser")
    admin_password                                    = optional(string)
    password                                          = optional(string)
    computer_name_prefix                              = optional(string)
    custom_data                                       = optional(string)
    user_data                                         = optional(string)
    disable_password_authentication                   = optional(bool, true)
    upgrade_mode                                      = optional(string, "Automatic")
    provision_vm_agent                                = optional(bool, true)
    platform_fault_domain_count                       = optional(number, 5)
    priority                                          = optional(string, "Regular")
    secure_boot_enabled                               = optional(bool, false)
    vtpm_enabled                                      = optional(bool, false)
    zone_balance                                      = optional(bool, false)
    zones                                             = optional(list(string), ["2"])
    edge_zone                                         = optional(string)
    encryption_at_host_enabled                        = optional(bool, false)
    extension_operations_enabled                      = optional(bool, true)
    extensions_time_budget                            = optional(string, "PT1H30M")
    overprovision                                     = optional(bool, true)
    capacity_reservation_group_id                     = optional(string)
    do_not_run_extensions_on_overprovisioned_machines = optional(bool, false)
    eviction_policy                                   = optional(string)
    health_probe_id                                   = optional(string)
    host_group_id                                     = optional(string)
    max_bid_price                                     = optional(number)
    proximity_placement_group_id                      = optional(string)
    single_placement_group                            = optional(bool, true)
    source_image_id                                   = optional(string)
    additional_capabilities = optional(object({
      ultra_ssd_enabled = optional(bool, false)
    }))
    tags                     = optional(map(string))
    public_key               = optional(string)
    enable_automatic_updates = optional(bool, true)
    hotpatching_enabled      = optional(bool, false)
    timezone                 = optional(string)
    patch_mode               = optional(string)
    license_type             = optional(string)
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = optional(string, "latest")
    }))
    os_disk = optional(object({
      storage_account_type             = optional(string, "Standard_LRS")
      caching                          = optional(string, "ReadWrite")
      disk_size_gb                     = optional(number)
      disk_encryption_set_id           = optional(string)
      security_encryption_type         = optional(string)
      write_accelerator_enabled        = optional(bool, false)
      secure_vm_disk_encryption_set_id = optional(string)
    }), {})
    diff_disk_settings = optional(object({
      option    = optional(string)
      placement = optional(string)
    }))
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
      auxiliary_mode                               = optional(string)
      auxiliary_sku                                = optional(string)
      network_security_group_id                    = optional(string)
      public_ip_address = optional(object({
        name                    = optional(string)
        domain_name_label       = optional(string)
        idle_timeout_in_minutes = optional(number)
        ip_tags = optional(map(object({
          type = string
          tag  = string
        })))
        public_ip_prefix_id = optional(string)
        version             = optional(string)
      }))
      ip_configuration = optional(object({
        version = optional(string)
      }))
    }))
    disks = optional(map(object({
      name                           = optional(string)
      caching                        = optional(string, "ReadWrite")
      create_option                  = optional(string, "Empty")
      disk_size_gb                   = optional(number, 10)
      lun                            = number
      storage_account_type           = optional(string, "Standard_LRS")
      disk_encryption_set_id         = optional(string)
      ultra_ssd_disk_iops_read_write = optional(number)
      ultra_ssd_disk_mbps_read_write = optional(number)
      write_accelerator_enabled      = optional(bool, false)
    })), {})
    extensions = optional(map(object({
      name                        = optional(string)
      publisher                   = string
      type                        = string
      type_handler_version        = string
      settings                    = optional(any, {})
      protected_settings          = optional(any, {})
      auto_upgrade_minor_version  = optional(bool, true)
      automatic_upgrade_enabled   = optional(bool, false)
      failure_suppression_enabled = optional(bool, false)
      provision_after_extensions  = optional(list(string), [])
      force_update_tag            = optional(string)
      protected_settings_from_key_vault = optional(object({
        secret_url      = string
        source_vault_id = string
      }))
    })), {})
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
    automatic_instance_repair = optional(object({
      enabled      = optional(bool, true)
      grace_period = optional(string, "PT30M")
      action       = optional(string)
    }))
    automatic_os_upgrade_policy = optional(object({
      disable_automatic_rollback  = optional(bool)
      enable_automatic_os_upgrade = optional(bool)
    }))
    gallery_applications = optional(map(object({
      version_id             = string
      configuration_blob_uri = optional(string)
      order                  = optional(number)
      tag                    = optional(string)
    })), {})
    identity = optional(object({
      type         = optional(string, "SystemAssigned")
      identity_ids = optional(list(string), [])
      name         = optional(string)
    }))
    plan = optional(object({
      name      = string
      publisher = string
      product   = string
    }))
    rolling_upgrade_policy = optional(object({
      cross_zone_upgrades_enabled             = optional(bool)
      max_batch_instance_percent              = optional(number)
      max_unhealthy_instance_percent          = optional(number)
      max_unhealthy_upgraded_instance_percent = optional(number)
      pause_time_between_batches              = optional(string)
      prioritize_unhealthy_instances_enabled  = optional(bool)
      maximum_surge_instances_enabled         = optional(bool)
    }))
    scale_in = optional(object({
      rule                   = optional(string)
      force_deletion_enabled = optional(bool)
    }))
    secrets = optional(map(object({
      key_vault_id = string
      certificate = object({
        store = optional(string)
        url   = string
      })
    })), {})
    spot_restore = optional(object({
      enabled = optional(bool, true)
      timeout = optional(string, "PT1H")
    }))
    termination_notification = optional(object({
      enabled = optional(bool, true)
      timeout = optional(string, "PT5M")
    }))
    winrm_listener = optional(object({
      certificate_url = optional(string)
      protocol        = optional(string)
    }))
    additional_unattend_content = optional(object({
      content = optional(string)
      setting = optional(string)
    }))
    generate_ssh_key = optional(object({
      enable           = optional(bool, false)
      algorithm        = optional(string, "RSA")
      rsa_bits         = optional(number, 4096)
      ecdsa_curve      = optional(string)
      expiration_date  = optional(string)
      not_before_date  = optional(string)
      value_wo_version = optional(number)
      value_wo         = optional(string)
      content_type     = optional(string)
    }), { enable = false })
    generate_password = optional(object({
      enable           = optional(bool, false)
      length           = optional(number, 24)
      special          = optional(bool, true)
      min_lower        = optional(number, 5)
      min_upper        = optional(number, 7)
      min_special      = optional(number, 4)
      min_numeric      = optional(number, 5)
      numeric          = optional(bool)
      upper            = optional(bool)
      lower            = optional(bool)
      override_special = optional(string)
      expiration_date  = optional(string)
      not_before_date  = optional(string)
      value_wo_version = optional(number)
      value_wo         = optional(string)
      content_type     = optional(string)
      keepers          = optional(map(string))
    }), { enable = false })
    autoscaling = optional(object({
      enabled      = optional(bool, true)
      name         = optional(string, "scaler")
      profile_name = optional(string, "default")
      min          = number
      max          = number
      default      = optional(number, 1)
      fixed_date = optional(object({
        end      = string
        start    = string
        timezone = optional(string)
      }))
      recurrence = optional(object({
        timezone = optional(string)
        days     = list(string)
        hours    = list(number)
        minutes  = list(number)
      }))
      notification = optional(object({
        email = optional(object({
          send_to_subscription_administrator    = optional(bool)
          send_to_subscription_co_administrator = optional(bool)
          custom_emails                         = optional(list(string))
        }))
        webhook = optional(list(object({
          service_uri = string
          properties  = optional(map(string))
        })))
      }))
      predictive = optional(object({
        scale_mode      = string
        look_ahead_time = optional(string)
      }))
      profiles = optional(list(object({
        name = string
        capacity = object({
          default = number
          minimum = number
          maximum = number
        })
        fixed_date = optional(object({
          end      = string
          start    = string
          timezone = optional(string)
        }))
        recurrence = optional(object({
          timezone = optional(string)
          days     = list(string)
          hours    = list(number)
          minutes  = list(number)
        }))
        rules = optional(list(object({
          metric_trigger = object({
            metric_name        = string
            metric_resource_id = optional(string)
            metric_namespace   = optional(string)
            time_aggregation   = string
            time_window        = string
            time_grain         = string
            operator           = string
            threshold          = number
            statistic          = string
            dimensions = optional(list(object({
              name     = string
              operator = string
              values   = list(string)
            })))
            divide_by_instance_count = optional(bool)
          })
          scale_action = object({
            direction = string
            type      = string
            value     = string
            cooldown  = string
          })
        })))
      })))
      rules = optional(map(object({
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
        metric_namespace = optional(string)
        dimensions = optional(list(object({
          name     = string
          operator = string
          values   = list(string)
        })))
        divide_by_instance_count = optional(bool)
      })))
    }))
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
    version   = optional(string, "latest")
  })
  default = null
}
