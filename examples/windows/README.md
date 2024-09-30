This example shows how to configure a scale set, using the windows operating system.

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
    type          = "windows"
    name          = module.naming.windows_virtual_machine_scale_set.name
    location      = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }
  }
}
```
