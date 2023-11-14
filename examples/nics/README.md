This section outlines the configuration of multiple network interfaces, enabling advanced networking capabilities and increased connectivity options.

## Usage:

```hcl
module "scaleset" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 0.1"

  vmss = {
    name          = module.naming.linux_virtual_machine_scale_set.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    keyvault      = module.kv.vault.id
    type          = "linux"

    interfaces = {
      internal = { subnet = module.network.subnets.internal.id, primary = true }
      mgmt     = { subnet = module.network.subnets.mgmt.id }
    }

    ssh_keys = {
      adminuser = {
        public_key = module.kv.tls_public_keys.vmss.value
      }
    }
  }
}
```
