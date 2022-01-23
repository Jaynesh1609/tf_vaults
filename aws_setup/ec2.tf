terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.23.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.17.0"
    }
  }
}



// this is our tfstate config about ec2.tf

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}


// this is about vault tfstate file


data "terraform_remote_state" "vaultest" {
  backend = "local"
  config = {
    path = var.path
  }
}


//this will contact with you vault an trying to give you key in accordance with


data "vault_aws_access_credentials" "vaultcred" {
  backend = data.terraform_remote_state.vaultest.outputs.backend
  role    = data.terraform_remote_state.vaultest.outputs.role
}

provider "aws" {
  region     = var.region
  access_key = data.vault_aws_access_credentials.vaultcred.access_key
  secret_key = data.vault_aws_access_credentials.vaultcred.secret_key
}


# Create AWS EC2 Instance
resource "aws_instance" "test" {
  ami           = "ami-0af25d0df86db00c1"
  instance_type = "t2.micro"

  tags = {
    Name = var.name
  }
}
