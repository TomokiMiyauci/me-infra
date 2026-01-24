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

variable "app_ipv4" {
  description = "Application IPv4"
  type        = string
}

variable "app_ipv6" {
  description = "Application IPv6"
  type        = string

}

variable "app_cname" {
  description = "Application required CNAME"
  type        = string
}
