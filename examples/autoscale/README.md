This example details the setup of autoscaling, ensuring dynamic scalability in response to workload changes.

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
    resource_group = module.rg.groups.demo.name
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

```hcl
locals {
  rules = {
    increase = {
      metric_name      = "Percentage CPU"
      time_grain       = "PT1M"
      statistic        = "Average"
      time_window      = "PT5M"
      time_aggregation = "Average"
      operator         = "GreaterThan"
      threshold        = 80
      direction        = "Increase"
      value            = 1
      cooldown         = "PT1M"
      type             = "ChangeCount"
    }
    decrease = {
      metric_name      = "Percentage CPU"
      time_grain       = "PT1M"
      statistic        = "Average"
      time_window      = "PT5M"
      time_aggregation = "Average"
      operator         = "LessThan"
      threshold        = 20
      direction        = "Decrease"
      value            = 1
      cooldown         = "PT1M"
      type             = "ChangeCount"
    }
  }
}
```