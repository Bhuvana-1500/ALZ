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
}

resource "azurerm_virtual_network" "vnet1" {
provider = azurerm.management
  for_each            = local.resource_groups1
  name                = each.value.vnet_name  # Access the single virtual network name as a string
  location            = each.value.location
  resource_group_name = each.value.name
  address_space       = each.value.address_space
}






