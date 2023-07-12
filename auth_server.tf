# Authorization Server
resource "okta_auth_server" "quote-auth-server" {
  audiences                 = ["https://${var.audience}"]
  credentials_rotation_mode = "AUTO"
  description               = var.env == "prd" ? "Quote Authorization Server" : "Quote Authorization Server ${var.env}"
  issuer_mode               = "CUSTOM_URL"
  name                      = var.env == "prd" ? "Quote Authorization Server" : "Quote Authorization Server ${var.env}"
  status                    = "ACTIVE"
}

# Authorization Server Scope
resource "okta_auth_server_scope" "groups" {
  auth_server_id   = okta_auth_server.quote-auth-server.id
  consent          = "IMPLICIT"
  default          = "false"
  description      = "Groups"
  display_name     = "Groups"
  metadata_publish = "NO_CLIENTS"
  name             = "groups"
}

# Authorization Server Claims
resource "okta_auth_server_claim" "approved" {
  always_include_in_token = "true"
  auth_server_id          = okta_auth_server.quote-auth-server.id
  claim_type              = "IDENTITY"
  name                    = "approved"
  status                  = "ACTIVE"
  value                   = "user.approved"
  value_type              = "EXPRESSION"
}

resource "okta_auth_server_claim" "userStatus" {
  always_include_in_token = "true"
  auth_server_id          = okta_auth_server.quote-auth-server.id
  claim_type              = "IDENTITY"
  name                    = "userStatus"
  status                  = "ACTIVE"
  value                   = "user.userStatus"
  value_type              = "EXPRESSION"
}

resource "okta_auth_server_claim" "internalAccountName" {
  always_include_in_token = "true"
  auth_server_id          = okta_auth_server.quote-auth-server.id
  claim_type              = "IDENTITY"
  name                    = "internalAccountName"
  status                  = "ACTIVE"
  value                   = "user.samAccountName"
  value_type              = "EXPRESSION"
}

resource "okta_auth_server_claim" "affiliatedAgencies" {
  always_include_in_token = "true"
  auth_server_id          = okta_auth_server.quote-auth-server.id
  claim_type              = "IDENTITY"
  name                    = "affiliatedAgencies"
  status                  = "ACTIVE"
  value                   = "user.affiliatedAgencies"
  value_type              = "EXPRESSION"
}

resource "okta_auth_server_claim" "agencyNumber" {
  always_include_in_token = "true"
  auth_server_id          = okta_auth_server.quote-auth-server.id
  claim_type              = "IDENTITY"
  name                    = "agencyNumber"
  status                  = "ACTIVE"
  value                   = "user.agencyNumber"
  value_type              = "EXPRESSION"
}

resource "okta_auth_server_claim" "groups" {
  always_include_in_token = "true"
  auth_server_id          = okta_auth_server.quote-auth-server.id
  claim_type              = "IDENTITY"
  group_filter_type       = "STARTS_WITH"
  name                    = "groups"
  status                  = "ACTIVE"
  value                   = "Quote"
  value_type              = "GROUPS"
}