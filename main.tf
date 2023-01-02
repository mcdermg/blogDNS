# Get external IP of myself
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "sops_file" "secrets" {
  source_file = "./secrets.enc.yaml"
}

# Zone for records related to celestial industries
# terraform import cloudflare_zone.celestialindustries 89f69cdeb73186bd90b2f45d8d171110
resource "cloudflare_zone" "celestialindustries" {
  paused = "false"
  plan   = "free"
  type   = "full"
  zone   = var.domian_name
  #zone   = data.sops_file.secrets.data["domian_name"]
}

# terraform import cloudflare_record.celestialindustries_info 89f69cdeb73186bd90b2f45d8d171110/4d80b2df0f3a91b005348bfe0c1517f9
resource "cloudflare_record" "celestialindustries_info" {
  name = var.domian_name
  #name    = data.sops_file.secrets.data["domian_name"]
  proxied = "true"
  ttl     = "1"
  type    = "A"
  value   = chomp(data.http.myip.body) #"186.22.152.169"
  zone_id = "89f69cdeb73186bd90b2f45d8d171110"
}

# terraform import cloudflare_record.celestialindustries_info_www 89f69cdeb73186bd90b2f45d8d171110/e7d3006c4f89680d4ca9a5f5449f63d7
resource "cloudflare_record" "celestialindustries_info_www" {
  name    = "www" # "www.${var.domian_name}"
  proxied = "true"
  ttl     = "1"
  type    = "A"
  value   = chomp(data.http.myip.body)
  zone_id = "89f69cdeb73186bd90b2f45d8d171110"
}

# Record used for GCP verification in GCP organization
# terraform import cloudflare_record.celestialindustries_gcp_ver 89f69cdeb73186bd90b2f45d8d171110/ac50056e45bfc3fbf2ed038a33e4ff82
resource "cloudflare_record" "celestialindustries_gcp_ver" {
  name = var.domian_name
  #name    = data.sops_file.secrets.data["domian_name"]
  proxied = "false"
  ttl     = "3600"
  type    = "TXT"
  value   = "google-site-verification=DSH0nqhJToYVFlO7p1vxUUaZXz_jO-7b0JNJOupjoRg"
  zone_id = "89f69cdeb73186bd90b2f45d8d171110"
}

# Maintanence page see https://hodovi.cc/blog/quick-pretty-and-easy-maintenance-page-using-cloudflare-workers-terraform/
// resource "cloudflare_worker_script" "this" {
//   name    = "maintenance"
//   content = file("./templates/maintenance.js")
// }
//
// resource "cloudflare_worker_route" "this" {
//   zone_id     = cloudflare_zone.celestialindustries.zone
//   pattern     = "${var.domian_name}/maintenance/*"
//   script_name = cloudflare_worker_script.this.name
// }
module "maintenance" {
  source  = "adinhodovic/maintenance/cloudflare"
  version = "~>0.6.0"

  count = var.maintenance ? 1 : 0

  cloudflare_zone = cloudflare_zone.celestialindustries.zone
  company_name    = "celestialindustries"
  email           = "support@celestialindustries.info"
  patterns        = ["*.${var.domian_name}"]
  #logo_url        = "https://s3.eu-west-1.amazonaws.com/honeylogic.io/media/images/Honeylogic-blue.original.png"
  logo_url = ""

  #statuspage_url  = "https://status.hodovi.cc"
  #font            = "Poppins"
  #favicon_url     = "https://s3.eu-west-1.amazonaws.com/honeylogic.io/media/images/Honeylogic_-_icon.original.height-80.png"
}
