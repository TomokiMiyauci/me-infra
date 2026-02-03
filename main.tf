provider "cloudflare" {
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

locals {
  origin       = "https://${var.domain}"
  service_name = "me"
  redirects = [
    {
      source_path = "/deno-lambda-cdk"
      target_path = "/en/posts/deno-lambda-cdk"
    },
    {
      source_path = "/module-from-string"
      target_path = "/en/posts/module-from-string"
    },
    {
      source_path = "/import-assertions-json-modules"
      target_path = "/en/posts/import-assertions-json-modules"
    },
    {
      source_path = "/dts-deno-module"
      target_path = "/en/posts/dts-deno-module"
    },
    {
      source_path = "/typescript-literal-hack"
      target_path = "/en/posts/typescript-literal-hack"
    },
    {
      source_path = "/lib-vite-tailwindcss"
      target_path = "/en/posts/lib-vite-tailwindcss"
    },
    {
      source_path = "/react-lazy-intersection"
      target_path = "/en/posts/react-lazy-intersection"
    },
    {
      source_path = "/fcm-push-message"
      target_path = "/en/posts/fcm-push-message"
    },
    {
      source_path = "/firebase-authentication-service-worker"
      target_path = "/en/posts/firebase-authentication-service-worker"
    },
    {
      source_path = "/cloud-functions-online-test"
      target_path = "/en/posts/cloud-functions-online-test"
    },
    {
      source_path = "/bitly-short-url"
      target_path = "/en/posts/bitly-short-url"
    },
    {
      source_path = "/firebase-bundle-size"
      target_path = "/en/posts/firebase-bundle-size"
    },
    {
      source_path = "/tweet-typescript"
      target_path = "/en/posts/tweet-typescript"
    },
    {
      source_path = "/gatsby-typescript"
      target_path = "/en/posts/gatsby-typescript"
    },
    {
      source_path = "/storybook-vite"
      target_path = "/en/posts/storybook-vite"
    },
    {
      source_path = "/exclusive-property"
      target_path = "/en/posts/exclusive-property"
    },
    {
      source_path = "/comment-system"
      target_path = "/en/posts/comment-system"
    },
    {
      source_path = "/typesafe-array-element"
      target_path = "/en/posts/typesafe-array-element"
    },
    {
      source_path = "/fetch-abort"
      target_path = "/en/posts/fetch-abort"
    },
    {
      source_path = "/jest-table-driven-tests"
      target_path = "/en/posts/jest-table-driven-tests"
    },
    {
      source_path = "/speeding-up-jest"
      target_path = "/en/posts/speeding-up-jest"
    },
    {
      source_path = "/vite-vue3-typescript"
      target_path = "/en/posts/vite-vue3-typescript"
    },
    {
      source_path = "/vite-vue3-tailwindcss"
      target_path = "/en/posts/vite-vue3-tailwindcss"
    },
    {
      source_path = "/vite-preact-typescript"
      target_path = "/en/posts/vite-preact-typescript"
    },
    {
      source_path = "/typescript-package-release"
      target_path = "/en/posts/typescript-package-release"
    },
    {
      source_path = "/typescript-conditional-types"
      target_path = "/en/posts/typescript-conditional-types"
    },
    {
      source_path = "/start-vitepress"
      target_path = "/en/posts/start-vitepress"
    },
    {
      source_path = "/file-dialog"
      target_path = "/en/posts/file-dialog"
    },
    {
      source_path = "/"
      target_path = "/en"
    },
  ]
}

resource "cloudflare_list" "bulk_redirect_list" {
  account_id  = var.account_id
  name        = "bulk_redirect_list_${var.env}"
  description = "Redirect list for default language path"
  kind        = "redirect"
  items = [
    for r in local.redirects : {
      redirect = {
        source_url  = "${local.origin}${r.source_path}"
        target_url  = "${local.origin}${r.target_path}"
        status_code = 301
      }
    }
  ]
}

resource "cloudflare_ruleset" "bulk_root_redirect_to_id" {
  account_id  = var.account_id
  name        = "bulk_redirect_ruleset_${var.env}"
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
  name       = "${local.service_name}-${var.env}"
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
  service     = "${local.service_name}-${var.env}"
  zone_id     = var.zone_id
  environment = "production"
}
