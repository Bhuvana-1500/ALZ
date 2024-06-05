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






