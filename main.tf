resource "azurerm_resource_group" "rg" {
  provider = azurerm.connectivity
  for_each = local.resource_groups
  name     = local.resource_groups[each.key].name
  location = local.resource_groups[each.key].location
}

resource "azurerm_resource_group" "rg1" {
  provider = azurerm.management
  for_each = local.resource_groups1
  name     = local.resource_groups1[each.key].name
  location = local.resource_groups1[each.key].location
}

# Create the virtual networks and subnets
resource "azurerm_virtual_network" "vnet" {
  provider = azurerm.connectivity
  for_each            = local.resource_groups
  name                = each.value.vnet_name  # Access the first virtual network name in the list
  location            = each.value.location
  resource_group_name = each.value.name
  address_space       = each.value.address_space
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_virtual_network" "vnet1" {
provider = azurerm.management
  for_each            = local.resource_groups1
  name                = each.value.vnet_name  # Access the single virtual network name as a string
  location            = each.value.location
  resource_group_name = each.value.name
  address_space       = each.value.address_space
  depends_on = [
    azurerm_resource_group.rg1
  ]
}

resource "azurerm_subnet" "subnet" {
  provider = azurerm.connectivity
for_each = local.subnets1
  name                 = "${each.key}"
  resource_group_name  = local.resource_groups.rg2.name
  virtual_network_name = local.resource_groups.rg2.vnet_name
  address_prefixes     = ["${each.value}"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "subnet1" {
  provider = azurerm.connectivity
for_each = local.subnets2
  name                 = "${each.key}"
  resource_group_name  = local.resource_groups.rg3.name
  virtual_network_name = local.resource_groups.rg3.vnet_name
  address_prefixes     = ["${each.value}"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
resource "azurerm_subnet" "subnet2" {
  provider = azurerm.management
for_each = local.subnets3
  name                 = "${each.key}"
  resource_group_name  = local.resource_groups1.rg4.name
  virtual_network_name = local.resource_groups1.rg4.vnet_name
  address_prefixes     = ["${each.value}"]
  depends_on = [
    azurerm_virtual_network.vnet1
  ]
}

resource "azurerm_virtual_network_peering" "example-1" {
  provider = azurerm.connectivity
  for_each = local.hub_peer
  name                      = local.hub_peer[each.key].name
  resource_group_name       = local.resource_groups.rg2.name
  virtual_network_name      = local.resource_groups.rg2.vnet_name
  remote_virtual_network_id = local.hub_peer[each.key].address_space
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_virtual_network_peering" "example-2" {
  provider = azurerm.connectivity
  for_each = local.spoke_peer
  name                      = local.spoke_peer[each.key].name
  resource_group_name       = local.spoke_peer[each.key].resource_group_name
  virtual_network_name      = local.spoke_peer[each.key].vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet["rg2"].id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_virtual_network_peering.example-1
  ]
}
resource "azurerm_virtual_network_peering" "example-3" {
  provider = azurerm.management
  for_each = local.peering
  name                      = local.peering["peer2"].name
  resource_group_name       = local.peering["peer2"].resource_group_name
  virtual_network_name      = local.peering["peer2"].vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet["rg2"].id
  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_virtual_network_peering.example-2
  ]
}
resource "azurerm_virtual_machine" "vms" {
  for_each = { for idx, vm in local.vms : idx => vm }
  provider = azurerm.connectivity
  name                  = each.value["name"]
  location              = each.value["location"]
  resource_group_name   = each.value["resource_group"]
  vm_size               = each.value["vm_size"]

  storage_image_reference {
    publisher = each.value["image_publisher"]
    offer     = each.value["image_offer"]
    sku       = each.value["image_sku"]
    version   = "latest"
  }

  os_profile {
    computer_name  = each.value["name"]
    admin_username = each.value["admin_username"]
    admin_password = each.value["admin_password"]
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

storage_os_disk {
    name              = "${each.value.name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = each.value.disk_size
    managed_disk_type = "Premium_LRS"
  }
  tags = {
    environment = "production"
  }

  network_interface_ids = [
    azurerm_network_interface.nics[each.key].id
  ]
  depends_on = [
    azurerm_network_interface.nics
  ]
}

# Create network interfaces
resource "azurerm_network_interface" "nics" {
  provider = azurerm.connectivity
  for_each = { for idx, vm in local.vms : idx => vm }
  name                = "${each.value["name"]}-nic"
  location            = each.value["location"]
  resource_group_name = each.value["resource_group"]

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet1[each.value["subnet_name"]].id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.subnet1
  ]
}






