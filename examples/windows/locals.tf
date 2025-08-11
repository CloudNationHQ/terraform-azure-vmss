locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret"]
}

locals {
  vmss = {
    type                = "windows"
    name                = module.naming.windows_virtual_machine_scale_set.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    source_image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2022-Datacenter"
    }

    generate_password = {
      enable = true
    }

    interfaces = {
      internal = {
        subnet  = module.network.subnets.internal.id
        primary = true
      }
    }
  }
}
