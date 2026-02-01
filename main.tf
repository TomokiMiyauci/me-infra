provider "cloudflare" {
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
  rules = [
    {
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
    },
    {
      description = "Redirect root to en"
      expression  = "(http.request.uri.path eq \"/\")"
      action      = "redirect"
      action_parameters = {
        from_value = {
          status_code = 301
          target_url = {
            value = "/en"
          }
          preserve_query_string = true
        }
      }
    },
  ]
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
        source_url  = "https://miyauchi.dev/posts/deno-lambda-cdk"
        target_url  = "https://miyauchi.dev/en/posts/deno-lambda-cdk"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/module-from-string"
        target_url  = "https://miyauchi.dev/en/posts/module-from-string"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/import-assertions-json-modules"
        target_url  = "https://miyauchi.dev/en/posts/import-assertions-json-modules"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/dts-deno-module"
        target_url  = "https://miyauchi.dev/en/posts/dts-deno-module"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/typescript-literal-hack"
        target_url  = "https://miyauchi.dev/en/posts/typescript-literal-hack"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/lib-vite-tailwindcss"
        target_url  = "https://miyauchi.dev/en/posts/lib-vite-tailwindcss"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/react-lazy-intersection"
        target_url  = "https://miyauchi.dev/en/posts/react-lazy-intersection"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/fcm-push-message"
        target_url  = "https://miyauchi.dev/en/posts/fcm-push-message"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/firebase-authentication-service-worker"
        target_url  = "https://miyauchi.dev/en/posts/firebase-authentication-service-worker"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/cloud-functions-online-test"
        target_url  = "https://miyauchi.dev/en/posts/cloud-functions-online-test"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/bitly-short-url"
        target_url  = "https://miyauchi.dev/en/posts/bitly-short-url"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/firebase-bundle-size"
        target_url  = "https://miyauchi.dev/en/posts/firebase-bundle-size"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/tweet-typescript"
        target_url  = "https://miyauchi.dev/en/posts/tweet-typescript"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/gatsby-typescript"
        target_url  = "https://miyauchi.dev/en/posts/gatsby-typescript"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/storybook-vite"
        target_url  = "https://miyauchi.dev/en/posts/storybook-vite"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/exclusive-property"
        target_url  = "https://miyauchi.dev/en/posts/exclusive-property"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/comment-system"
        target_url  = "https://miyauchi.dev/en/posts/comment-system"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/typesafe-array-element"
        target_url  = "https://miyauchi.dev/en/posts/typesafe-array-element"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/fetch-abort"
        target_url  = "https://miyauchi.dev/en/posts/fetch-abort"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/jest-table-driven-tests"
        target_url  = "https://miyauchi.dev/en/posts/jest-table-driven-tests"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/speeding-up-jest"
        target_url  = "https://miyauchi.dev/en/posts/speeding-up-jest"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/vite-vue3-typescript"
        target_url  = "https://miyauchi.dev/en/posts/vite-vue3-typescript"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/vite-vue3-tailwindcss"
        target_url  = "https://miyauchi.dev/en/posts/vite-vue3-tailwindcss"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/vite-preact-typescript"
        target_url  = "https://miyauchi.dev/en/posts/vite-preact-typescript"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/typescript-package-release"
        target_url  = "https://miyauchi.dev/en/posts/typescript-package-release"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/typescript-conditional-types"
        target_url  = "https://miyauchi.dev/en/posts/typescript-conditional-types"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/start-vitepress"
        target_url  = "https://miyauchi.dev/en/posts/start-vitepress"
        status_code = 301
      }
    },
    {
      redirect = {
        source_url  = "https://miyauchi.dev/posts/file-dialog"
        target_url  = "https://miyauchi.dev/en/posts/file-dialog"
        status_code = 301
      }
    },
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

resource "cloudflare_worker" "app_worker" {
  account_id = var.account_id
  name       = "me-production"
  logpush    = false
  observability = {
    enabled            = true
    head_sampling_rate = 1
    logs = {
      enabled            = true
      head_sampling_rate = 1
      invocation_logs    = true
    }
  }
  subdomain = {
    enabled          = true
    previews_enabled = false
  }
  tags           = []
  tail_consumers = []
}

resource "cloudflare_workers_custom_domain" "workers_custom_domain" {
  account_id  = var.account_id
  hostname    = var.domain
  service     = "me-production"
  zone_id     = var.zone_id
  environment = "production"
}
