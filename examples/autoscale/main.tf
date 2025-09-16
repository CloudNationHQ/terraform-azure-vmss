module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.18.0.0/16"]

    subnets = {
      internal = { address_prefixes = ["10.18.1.0/24"] }
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 4.0"

  naming = local.naming

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "scaleset" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 2.0"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

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

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }
  }
}
