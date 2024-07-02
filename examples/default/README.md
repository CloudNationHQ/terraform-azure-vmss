This example illustrates the default virtual machine scale set setup, in its simplest form.

## Usage: default

```hcl
module "scaleset" {
  source = "cloudnationhq/vmss/azure"
  version = "~> 0.5"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  vmss = {
    type          = "linux"
    name          = module.naming.linux_virtual_machine_scale_set.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }
  }
}
```

Additionally, for certain scenarios, the example below highlights the ability to use multiple scale sets, enabling a broader setup.

## Usage: multiple

```hcl
module "scalesets" {
  source = "cloudnationhq/vmss/azure"
  version = "~> 0.1"

  naming        = local.naming
  keyvault      = module.kv.vault.id
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
  depends_on    = [module.kv]

  for_each = local.scalesets

  vmss = each.value
}
```

The module uses a local to iterate, generating a scale set for each key.

```hcl
locals {
  scalesets = {
    sc1 = {
      name          = "vmss-demo-dev-001"
      type          = "linux"

      interfaces = {
        internal = {
          subnet = module.network.subnets.internal.id
          primary = true
        }
      }
    },
    sc2 = {
      name          = "vmss-demo-dev-002"
      type          = "linux"

      interfaces = {
        internal = {
          subnet = module.network.subnets.internal.id
          primary = true
        }
      }
    }
  }
}
```
