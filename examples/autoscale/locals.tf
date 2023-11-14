locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret"]
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
