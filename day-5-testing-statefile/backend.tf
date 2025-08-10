terraform {
  backend "s3" {
    bucket = "snlshdjopsj"
    key    = "day-5/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true #s3 supports this feature for terraform version > 1.10
   # dynamodb_table = "Test" # used for statefile locking of any version mostly for old versions
    encrypt = true
  }
}