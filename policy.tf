resource "azurerm_resource_group_policy_assignment" "policyassignment" {
  for_each = { for p in csvdecode(file("${path.module}/Policy.csv")): p.displayname => p }
  
  name                  = substr(replace(each.key, " ", "-"), 0, 24)
  display_name          = each.value.displayname
  policy_definition_id  = each.value.policyid
  resource_group_id     = "/subscriptions/13ba43d9-3859-4c70-9f8d-182debaa038b/resourceGroups/rg-hub-uks" 
}
