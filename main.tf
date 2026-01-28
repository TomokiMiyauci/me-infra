provider "cloudflare" {
}

resource "cloudflare_dns_record" "terraform_managed_resource_762cb682fd712fdd05e02e2f2d20390b_0" {
  content  = var.app_ipv4
  name     = "@"
  proxied  = true
  tags     = []
  ttl      = 1
  type     = "A"
  zone_id  = var.zone_id
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_b4961193b72ee94772733dc771dc846d_1" {
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

resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = var.zone_id
  setting_id = "always_use_https"
  value      = "on"
}

resource "cloudflare_zone_setting" "automatic_https_rewrites" {
  zone_id    = var.zone_id
  setting_id = "automatic_https_rewrites"
  value      = "on"
}

resource "cloudflare_zone_setting" "min_tls_version" {
  zone_id    = var.zone_id
  setting_id = "min_tls_version"
  value      = "1.0"
}

resource "cloudflare_zone_setting" "tls_1_3" {
  zone_id    = var.zone_id
  setting_id = "tls_1_3"
  value      = "on"
}

resource "cloudflare_zone_setting" "http3" {
  zone_id    = var.zone_id
  setting_id = "http3"
  value      = "on"
}

resource "cloudflare_r2_bucket" "me_www" {
  account_id    = var.account_id
  name          = var.bucket_name
  storage_class = "Standard"
}

resource "cloudflare_r2_custom_domain" "r2_custom_domain" {
  account_id  = var.account_id
  bucket_name = cloudflare_r2_bucket.me_www.name
  domain      = "static.${var.domain}"
  enabled     = true
  zone_id     = var.zone_id
  min_tls     = "1.0"
}

resource "cloudflare_cloud_connector_rules" "cloud_connector_rules" {
  zone_id = var.zone_id

  rules = [
    {
      provider    = "cloudflare_r2"
      description = "Route ads.txt"
      expression  = "(http.request.uri.path eq \"/ads.txt\")"
      parameters = {
        host = "static.${var.domain}"
      }
      enabled = true
    },
    {
      provider    = "cloudflare_r2"
      description = "Route robots.txt"
      expression  = "(http.request.uri.path eq \"/robots.txt\")"
      parameters = {
        host = "static.${var.domain}"
      }
      enabled = true
    }
  ]
}

resource "cloudflare_list" "bulk_redirect_list" {
  account_id  = var.account_id
  name        = "bulk_redirect_list"
  description = "Redirect list for default language path"
  kind        = "redirect"
  items = [
    {
      redirect = {
        source_url  = "https://miyauchi.dev/test"
        target_url  = "https://miyauchi.dev"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/test2"
        target_url  = "https://miyauchi.dev"
        status_code = 301
      }
    }
  ]
}


resource "cloudflare_ruleset" "bulk_root_redirect_to_id" {
  account_id  = var.account_id
  name        = "bulk_redirect_ruleset"
  description = "Bulk redirect ruleset"
  kind        = "root"
  phase       = "http_request_redirect"

  rules = [{
    action = "redirect"
    action_parameters = {
      from_list = {
        name = cloudflare_list.bulk_redirect_list.name
        key  = "http.request.full_uri"
      }
    }
    expression = "http.request.full_uri in ${"$"}${cloudflare_list.bulk_redirect_list.name}"
    enabled    = true
  }]
}
