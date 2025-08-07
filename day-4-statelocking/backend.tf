terraform {
  backend "s3" {
    bucket = "ssppewd"
    key    = "day-4/terraform.tfstate"
    region = "us-east-1"
  }
}