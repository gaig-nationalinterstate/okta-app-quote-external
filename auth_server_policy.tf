resource "okta_auth_server_policy" "quote-policy" {
  auth_server_id   = okta_auth_server.quote-auth-server.id
  client_whitelist = [okta_app_oauth.quote.id]
  description      = var.env == "prd" ? "Quote Access Policy" : "Quote Access Policy ${var.env}"
  name             = var.env == "prd" ? "Quote Access Policy" : "Quote Access Policy ${var.env}"
  priority         = "1"
  status           = "ACTIVE"
}

# Policy Rule
resource "okta_auth_server_policy_rule" "quote-rule" {
  auth_server_id                = okta_auth_server.quote-auth-server.id
  policy_id                     = okta_auth_server_policy.quote-policy.id
  status                        = "ACTIVE"
  name                          = var.env == "prd" ? "Default Policy Rule" : "Default Policy Rule ${var.env}"
  priority                      = 1
  group_whitelist               = ["EVERYONE"]
  grant_type_whitelist          = ["authorization_code", "implicit"]
  scope_whitelist               = ["*"]
  access_token_lifetime_minutes = 60
  refresh_token_window_minutes  = 10080
}