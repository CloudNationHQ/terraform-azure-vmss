This example details the setup of autoscaling, ensuring dynamic scalability in response to workload changes.

## Usage:

```hcl
module "scaleset" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 0.2"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  vmss = {
    name          = module.naming.linux_virtual_machine_scale_set.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    autoscaling = {
      min   = 1
      max   = 5
      rules = local.rules
    }

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }
  }
}
```
