This section outlines the configuration of multiple network interfaces, enabling advanced networking capabilities and increased connectivity options.

## Usage:

```hcl
module "scaleset" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 0.6"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  vmss = local.vmss
}
```

The module uses the below locals for configuration:

```hcl
locals {
  vmss = {
    name          = module.naming.linux_virtual_machine_scale_set.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id,
        primary = true
      }
      mgmt = {
        subnet = module.network.subnets.mgmt.id
      }
    }
  }
}
```
