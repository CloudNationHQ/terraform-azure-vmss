# Virtual Machine Scale Set

This terraform module simplifies the configuration and management of virtual machine scale sets. It offers extensive customization options to match your specific deployment needs, streamlining the provisioning and maintenance process.

## Features

Flexibility to incorporate multiple extensions

Utilization of Terratest for robust validation

Ability to use multiple interfaces and disks

Supports both system and multiple user assigned identities

Supports custom data integration

Compatible with both Linux and Windows environments

Supports availability sets to enhance fault tolerance and availability

Autoscaling with predictive capabilities and custom profiles

Automatic SSH key and password generation with Key Vault integration

Support for spot instances with configurable eviction policies

Rolling upgrade policies with surge capacity and health monitoring

Boot diagnostics and automatic instance repair functionality

Gallery application deployment support

Encryption at host with disk encryption set integration

Public IP address configuration with custom IP tags

Ultra SSD support with configurable IOPS and throughput

Termination notifications and spot restore capabilities

Validation rules for configuration consistency

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

- <a name="requirement_tls"></a> [tls](#requirement\_tls) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.6)

- <a name="provider_tls"></a> [tls](#provider\_tls) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_key_vault_secret.secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.tls_private_key_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.tls_public_key_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_linux_virtual_machine_scale_set.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) (resource)
- [azurerm_monitor_autoscale_setting.scaling](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) (resource)
- [azurerm_virtual_machine_scale_set_extension.ext](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) (resource)
- [azurerm_windows_virtual_machine_scale_set.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) (resource)
- [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [tls_private_key.tls_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) (resource)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_vmss"></a> [vmss](#input\_vmss)

Description: Contains all virtual machine scale set configuration

Type:

```hcl
object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_keyvault"></a> [keyvault](#input\_keyvault)

Description: keyvault id to store secrets

Type: `string`

Default: `null`

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region and can be used if location is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: used for naming purposes

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group and can be used if resourcegroup is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference)

Description: Default source image reference configuration to use when not specified at the vmss level

Type:

```hcl
object({
    publisher = string
    offer     = string
    sku       = string
    version   = optional(string, "latest")
  })
```

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_subscriptionId"></a> [subscriptionId](#output\_subscriptionId)

Description: contains the current subscription id

### <a name="output_vmss"></a> [vmss](#output\_vmss)

Description: contains all virtual machine scale set config
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-vmss/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-vmss" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/compute/virtual-machine-scale-sets)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/compute/resource-manager/Microsoft.Compute/ComputeRP/stable/2023-07-01/virtualMachineScaleSet.json)
