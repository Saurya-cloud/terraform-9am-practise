terraform {
  backend "s3" {
    bucket = "ssppewd"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
