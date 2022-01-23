terraform {
  backend "s3" {
    bucket = "ur_bucket_name"
    key    = "state1/terraform.tfstate"
    region = "ap-south-1"
  }
}
