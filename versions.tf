terraform {
  required_version = "~> 1.2.3"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.17"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.7"
    }
  }
}

provider "cloudflare" {
  //api_token  = var.cloudflare_api_token
  //account_id = var.cloudflare_account_id
  api_token  = data.sops_file.secrets.data["cloudflare_api_token"]
  account_id = data.sops_file.secrets.data["cloudflare_account_id"]
}

provider "aws" {
  region  = "ca-central-1"
  profile = "terraform"
}