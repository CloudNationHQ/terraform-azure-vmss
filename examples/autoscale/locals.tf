locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret"]
}

locals {
  vmss = {
    name                = module.naming.linux_virtual_machine_scale_set.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    type                = "linux"

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
    }

    generate_ssh_key = {
      enable = true
    }

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
