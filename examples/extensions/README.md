This example illustrates the implementation of extensions.

## Usage:

```hcl
module "scaleset" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 0.2"

  vmss = {
    name           = module.naming.linux_virtual_machine_scale_set.name
    location       = module.rg.groups.demo.location
    resourcegroup  = module.rg.groups.demo.name
    keyvault       = module.kv.vault.id
    type           = "linux"

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }

    extensions = {
      DAExtension = {
        publisher            = "Microsoft.Azure.Monitoring.DependencyAgent"
        type                 = "DependencyAgentLinux"
        type_handler_version = "9.5"
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
