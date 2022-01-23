terraform {
  backend "s3" {
    bucket = "you_bucket_name"
    key    = "state/terraform.tfstate"
    region = "ap-south-1"
  }
}
