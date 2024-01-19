This example illustrates the default virtual machine scale set setup, in its simplest form.

## Usage: default

```hcl
module "scaleset" {
  source = "cloudnationhq/vmss/azure"
  version = "~> 0.2"

  vmss = {
    name          = module.naming.linux_virtual_machine_scale_set.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    keyvault      = module.kv.vault.id
    type          = "linux"

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }

    ssh_keys = {
      adminuser = {
        public_key = module.kv.tls_public_keys.vmss.value
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

  for_each = local.scalesets

  vmss = each.value
}
```

The module uses a local to iterate, generating a scale set for each key.

```hcl
locals {
  scalesets = {
    sc1 = {
      name          = join("-", [module.naming.linux_virtual_machine_scale_set.name, "001"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      keyvault      = module.kv.vault.id
      type          = "linux"

      interfaces = {
        internal = {
          subnet = module.network.subnets.internal.id
          primary = true
        }
      }

      ssh_keys = {
        adminuser = {
          public_key = module.kv.tls_public_keys.vmss.value
        }
      }
    },
    sc2 = {
      name          = join("-", [module.naming.linux_virtual_machine_scale_set.name, "002"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      keyvault      = module.kv.vault.id
      type          = "linux"

      interfaces = {
        internal = {
          subnet = module.network.subnets.internal.id
          primary = true
        }
      }

      ssh_keys = {
        adminuser = {
          public_key = module.kv.tls_public_keys.vmss.value
        }
      }
    },
  }
}
```
