This example details the setup of autoscaling, ensuring dynamic scalability in response to workload changes.

## Usage:

```hcl
module "scaleset" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 0.2"

  vmss = {
    name          = module.naming.virtual_machine_scale_set.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    keyvault      = module.kv.vault.id
    type          = "linux"

    autoscaling   = {
      min = 1
      max = 5
      rules = local.rules
    }

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
