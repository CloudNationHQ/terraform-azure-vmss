# Virtual Machine Scale Set

This Terraform module simplifies the configuration and management of virtual machine scale sets. It offers extensive customization options to match your specific deployment needs, streamlining the provisioning and maintenance process.

## Features

Flexibility to incorporate multiple extensions

Utilization of Terratest for robust validation

Ability to use multiple interfaces and disks

Supports both system and multiple user assigned identities

Supports custom data integration

Compatible with both Linux and Windows environments

Supports availability sets to enhance fault tolerance and availability

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
    version   = string
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