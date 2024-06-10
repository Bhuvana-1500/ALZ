# Define root management group properties
locals {
  root_management_group = {
    name                       = "Tenant Root Group"
    display_name               = "Tenant Root Group"
    parent_management_group_id = null  # Since it's the root group
    subscription_ids           = ["13ba43d9-3859-4c70-9f8d-182debaa038b","bd73b938-1dbc-4f3a-84ec-51e240f8bd64"]    # No subscriptions at root level
  }
}

locals {
  resource_groups = {
    rg1 = {
      name     = "rg-shared-uks"
      location = "UK South"
      vnet_name= "vnet-shared-uks"
      address_space=["10.10.254.0/23"]
    }
    rg2 = {
      name     = "rg-hub-uks"
      location = "UK South"
      vnet_name= "vnet-hub-uks"
      address_space=["10.10.0.0/21"]
    }
    rg3 = {
      name     = "rg-prod-uks"
      location = "UK South"
      vnet_name= "vnet-prod-uks"
      address_space=["10.10.8.0/21"]
    }
  }
  resource_groups1={
    rg4 ={
      name="rg-test-uks"
      location="UK South"
      vnet_name= "vnet-test-uks"
      address_space=["10.10.16.0/21"]
    }
  }
}

locals {
  subnets1={
    snet-untrust-uks="10.10.0.0/26"
    snet-trust-uks="10.10.0.64/26"
    snet-ha-uks="10.10.0.128/26"
    snet-mgmt-uks="10.10.0.192/26"
    snet-temp-uks="10.10.1.0/24"
    snet-aruba-internal-uks="10.10.2.0/24"
    
  }
  subnets2={
    snet-app-prod-uks="10.10.8.0/24"
    snet-data-prod-uks="10.10.9.0/24"
    snet-web-prod-uks="10.10.10.0/24"
    snet-serv-prod-uks="10.10.11.0/24"
  }
  subnets3={
    snet-app-test-uks="10.10.16.0/24"
    snet-data-test-uks="10.10.17.0/24"
    snet-web-test-uks="10.10.18.0/24"
    snet-serv-test-uks="10.10.19.0/24"
  }
}

locals{
  hub_peer={
    peer1={
      name="vnet-hub-peering-vnet-prod"
      address_space=azurerm_virtual_network.vnet["rg3"].id
    }
    peer2={
    name="vnet-hub-peering-vnet-test"
    address_space=azurerm_virtual_network.vnet1["rg4"].id
    }
    peer3={
      name="vnet-hub-peering-vnet-shared"
      address_space=azurerm_virtual_network.vnet["rg1"].id
    }
  }
  spoke_peer={
    peer1={
    name="vnet-prod-peering-vnet-hub"
    vnet_name= "vnet-prod-uks"
    resource_group_name=local.resource_groups.rg3.name
  }
    peer3={
      name="vnet-shared-peering-vnet-hub"
      vnet_name= "vnet-shared-uks"
      resource_group_name=local.resource_groups.rg1.name
    }
  }
  peering={
    peer2={
      name="vnet-test-peering-vnet-hub"
      vnet_name= "vnet-test-uks"
      resource_group_name=local.resource_groups1.rg4.name
    }
  }
}

locals {
  vms = [
    {
      name               = "vm1"
      location           = local.resource_groups.rg3.location
      resource_group     = local.resource_groups.rg3.name
      vnet_name          = local.resource_groups.rg3.vnet_name
      subnet_name        = keys(local.subnets2)[0]  
      image_offer        = "WindowsServer"
      image_publisher    = "MicrosoftWindowsServer"
      image_sku          = "2022-Datacenter"
      vm_size            = "Standard_DS1_v2"
      disk_size=127
      admin_username="VM1"
      admin_password="Bhuvaneswari@15"
    },
    {
      name               = "vm2"
      location           = local.resource_groups.rg3.location
      resource_group     = local.resource_groups.rg3.name
      vnet_name          = local.resource_groups.rg3.vnet_name
      subnet_name        = keys(local.subnets2)[1]
      image_offer        = "WindowsServer"
      image_publisher    = "MicrosoftWindowsServer"
      image_sku          = "2019-Datacenter"
      vm_size            = "Standard_DS1_v2"
      disk_size=127
      admin_username="VM2"
      admin_password="Bhuvaneswari@15"
    }
  ]
}

