variable "domian_name" {
  type        = string
  description = "Domain name"
}

#variable "cloudflare_api_token" {
#  type        = string
#  description = "Cloudflare API token"
#}
#
#variable "cloudflare_account_id" {
#  type        = string
#  description = "Cloudflare account ID"
#}

variable "maintenance" {
  type        = bool
  description = "Whether to enable maintenance page via Cloudflare worker"
  default     = false
}

