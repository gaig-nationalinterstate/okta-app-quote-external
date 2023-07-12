resource "okta_trusted_origin" "quote" {
  name   = var.env == "prd" ? "Quote NATL" : "Quote NATL ${var.env}"
  origin = "https://${var.audience}"
  scopes = ["CORS", "REDIRECT"]
}