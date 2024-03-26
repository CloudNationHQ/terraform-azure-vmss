locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret"]
}

locals {
  vmss = {
    name          = module.naming.linux_virtual_machine_scale_set.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id,
        primary = true
      }
      mgmt = {
        subnet = module.network.subnets.mgmt.id
      }
    }
  }
}
