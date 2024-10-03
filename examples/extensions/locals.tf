locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret"]
}

locals {
  vmss = {
    name           = module.naming.linux_virtual_machine_scale_set.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    type           = "linux"

    extensions = local.extensions

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }
  }
}

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
