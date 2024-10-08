locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret", "managed_disk"]
}

locals {
  vmss = {
    name           = module.naming.linux_virtual_machine_scale_set.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    type           = "linux"

    autoscaling = {
      min = 1
      max = 5
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
    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }
    disks = {
      db = {
        size_gb = 10
        lun     = 0
      }
      logs = {
        size_gb = 12
        lun     = 1
      }
    }
  }
}
