variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "bucket_name" {
  description = "Bucket name"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "dns_records" {
  description = "DNS records"
  type = map(object({
    name    = string
    type    = string
    content = string
    proxied = bool
  }))
}
