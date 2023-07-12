# Groups
# If not prod, these groups will be created. If prod, will use the existing data source for ID. 
resource "okta_group" "Quote_Underwriters" {
  description = var.env == "prd" ? "Quote Underwriters Group" : "Quote Underwriters Group ${var.env}"
  name        = var.env == "prd" ? "Quote_Underwriters" : "Quote_Underwriters_${var.env}"
}

resource "okta_group" "Quote_Agents" {
  description = var.env == "prd" ? "Quote Agents Group" : "Quote Agents Group ${var.env}"
  name        = var.env == "prd" ? "Quote_Agents" : "Quote_Agents_${var.env}"
}

resource "okta_group" "Agents" {
  description = var.env == "prd" ? "Agents Group" : "Agents Group ${var.env}"
  name        = var.env == "prd" ? "Agents" : "Agents_${var.env}"
}

resource "okta_group" "External_Users" {
  description = "Self-Service Registration Users"
  name        = var.env == "prd" ? "External_Users" : "External_Users_${var.env}"
}

# Group Rules
resource "okta_group_rule" "Quote-Agents-Provisioning-Rule" {
  expression_value  = var.env == "prd" ? "user.userStatus==\"Approved\" and isMemberOfGroupName(\"Agents\")" : "user.userStatus==\"Approved\" and isMemberOfGroupName(\"Agents_${var.env}\")"
  group_assignments = [okta_group.Quote_Agents.id]
  name              = var.env == "prd" ? "Quote Agents Provisioning Rule" : "Quote Agents Provisioning Rule ${var.env}"
  status            = "ACTIVE"
}

resource "okta_group_rule" "Assign-External-Users-Group" {
  count             = var.env != "prd" ? 1 : 0
  expression_value  = "isMemberOfAnyGroup(\"${okta_group.Quote_Agents.id}\")"
  group_assignments = [okta_group.External_Users.id]
  name              = "Assign to External Users Group ${var.env}"
  status            = "ACTIVE"
}

# Data source to read user ID and be used in prod for user exclusion. Follow same data configuration as below to add any other users for exclusion.
data "okta_user" "Vipen-Kundra" {
  count = var.env == "prd" ? 1 : 0
  search {
    name  = "profile.firstName"
    value = "Vipen"
  }

  search {
    name  = "profile.lastName"
    value = "Kundra"
  }
}

resource "okta_group_rule" "Assign-External-Users-Group-Exclude" {
  count             = var.env == "prd" ? 1 : 0
  expression_value  = "isMemberOfAnyGroup(\"${okta_group.Quote_Agents.id}\")"
  group_assignments = [okta_group.External_Users.id]
  name              = "Assign to External Users Group"
  status            = "ACTIVE"
  users_excluded    = [data.okta_user.Vipen-Kundra[0].id]
}
