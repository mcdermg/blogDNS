terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-state-bucket-mcdermg"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "eu-west-1"
    key            = "terraform/blog_dns"
  }
}