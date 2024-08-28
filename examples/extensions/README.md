This example illustrates the implementation of extensions.

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

    extensions = local.extensions

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }
  }
}
```

```hcl
locals {
  extensions = {
    custom = {
      publisher            = "Microsoft.Azure.Extensions"
      type                 = "CustomScript"
      type_handler_version = "2.0"
      settings = {
        "commandToExecute" = "echo 'Hello World' > /tmp/helloworld.txt"
      }
    }
  }
}
```


