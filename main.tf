provider "cloudflare" {
}

resource "cloudflare_dns_record" "terraform_managed_resource_886c472d3f79b6146ef489cf29bb1b53_0" {
  content  = var.app_ipv4
  name     = "@"
  proxied  = true
  tags     = []
  ttl      = 1
  type     = "A"
  zone_id  = var.zone_id
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_e0019dfa9f829e4f486a996705f66e16_1" {
  content  = var.app_ipv6
  name     = "@"
  proxied  = true
  tags     = []
  ttl      = 1
  type     = "AAAA"
  zone_id  = var.zone_id
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_62ffa70f6f924bb6ea2f2d35edeb5826_2" {
  content = var.app_cname
  name    = "_acme-challenge.${var.domain}"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = var.zone_id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "www" {
  content = var.app_ipv4
  name    = "www"
  proxied = true
  zone_id = var.zone_id
  ttl     = 1
  type    = "A"
}

resource "cloudflare_url_normalization_settings" "terraform_managed_resource_c1012733de4b7c6521d7601b1a219e05_0" {
  scope   = "both"
  type    = "cloudflare"
  zone_id = var.zone_id
}

resource "cloudflare_ruleset" "terraform_managed_resource_8aace1f833de4e62bc43a6c838fc850b_1" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_dynamic_redirect"
  zone_id = var.zone_id
  rules = [{
    description = "Redirect www to apex"
    expression  = "(http.request.full_uri wildcard \"https://www.*\")"
    action      = "redirect"
    action_parameters = {
      from_value = {
        status_code = 301
        target_url = {
          expression = "wildcard_replace(http.request.full_uri, \"https://www.*\", \"https://$${1}\")"
        }
        preserve_query_string = true
      }
    }
  }]
}

resource "cloudflare_ruleset" "terraform_managed_resource_febee8292d4b4e80817b41c0d44d9a0f_0" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_cache_settings"
  zone_id = var.zone_id
  rules = [{
    action = "set_cache_settings"
    action_parameters = {
      cache = true
    }
    description = "Default Caching"
    expression  = "true"
  }]
}

resource "cloudflare_managed_transforms" "terraform_managed_resource_c1012733de4b7c6521d7601b1a219e05_0" {
  zone_id                 = var.zone_id
  managed_request_headers = []
  managed_response_headers = [{
    enabled = true
    id      = "add_security_headers"
  }]
}
