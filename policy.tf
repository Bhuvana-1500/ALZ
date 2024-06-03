resource "azurerm_management_group_policy_assignment" "policyassignment" {
  for_each = { for p in csvdecode(file("${path.module}/Policy.csv")): p.displayname => p }
  
  name                  = substr(replace(each.key, " ", "-"), 0, 24)
  display_name          = each.value.displayname
  policy_definition_id  = each.value.policyid
  management_group_id   = azurerm_management_group.root.id
}

