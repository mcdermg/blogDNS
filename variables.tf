variable "domian_name" {
  type        = string
  description = "Domain name"
}

variable "maintenance" {
  type        = bool
  description = "Whether to enable maintenance page via Cloudflare worker"
  default     = false
}
