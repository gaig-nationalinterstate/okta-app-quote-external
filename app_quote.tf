resource "okta_app_oauth" "quote" {
  accessibility_self_service = "false"
  auto_key_rotation          = "true"
  auto_submit_toolbar        = "false"
  consent_method             = "TRUSTED"
  grant_types                = ["authorization_code", "implicit", "refresh_token"]
  hide_ios                   = "true"
  hide_web                   = "true"
  implicit_assignment        = "false"
  issuer_mode                = "CUSTOM_URL"
  label                      = var.env == "prd" ? "Quote Commercial Lines" : "Quote Commercial Lines ${var.env}"
  login_mode                 = "DISABLED"
  login_uri                  = "https://${var.uri}/Account/Login"
  logo_uri                   = "https://ok14static.oktacdn.com/fs/bcg/4/gfs3v99auyS5uQZJF696"
  pkce_required              = "false"
  post_logout_redirect_uris  = ["https://${var.uri}/Account/PostLogout"]
  redirect_uris              = ["https://${var.uri}/authorization-code/callback"]
  refresh_token_leeway       = "30"
  refresh_token_rotation     = "ROTATE"
  response_types             = ["code", "id_token", "token"]
  status                     = "ACTIVE"
  token_endpoint_auth_method = "client_secret_basic"
  type                       = "web"
  user_name_template_type    = "BUILT_IN"
  wildcard_redirect          = "DISABLED"

  lifecycle {
    ignore_changes = [groups]
  }
}

# Assign groups to Quote Commercial Lines
resource "okta_app_group_assignment" "Quote_Agents" {
  app_id            = okta_app_oauth.quote.id
  group_id          = okta_group.Quote_Agents.id
  retain_assignment = true
}

resource "okta_app_group_assignment" "Quote_Underwriters_oauth" {
  app_id            = okta_app_oauth.quote.id
  group_id          = okta_group.Quote_Underwriters.id
  retain_assignment = true
}

# Bookmark
resource "okta_app_bookmark" "commercial-lines" {
  accessibility_self_service = "false"
  groups                     = [okta_group.Quote_Underwriters.id, okta_group.Quote_Agents.id ]
  hide_ios                   = "false"
  hide_web                   = "false"
  label                      = var.env == "prd" ? "National Interstate Commercial Lines" : "National Interstate Commercial Lines ${var.env}"
  request_integration        = "false"
  status                     = "ACTIVE"
  url                        = "https://${var.uri}"

  lifecycle {
    ignore_changes = [groups]
  }
}

# Assign Groups to Commercial Lines Bookmark
resource "okta_app_group_assignment" "Quote_Underwriters_bookmark" {
  app_id            = okta_app_bookmark.commercial-lines.id
  group_id          = okta_group.Quote_Underwriters.id
  retain_assignment = true
}

resource "okta_app_group_assignment" "Quote_Agents_bookmark" {
  app_id            = okta_app_bookmark.commercial-lines.id
  group_id          = okta_group.Quote_Agents.id
  retain_assignment = true
}